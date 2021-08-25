defmodule Steinadler do
  @moduledoc """
  `Steinadler`.
  """
  use Supervisor
  import Cachex.Spec
  require Logger

  alias Injectx.Context

  @impl true
  def init(args) do
    Context.from_config()
    port = Keyword.get(args, :default_port, 4_000)
    Application.put_env(:grpc, :start_server, true, persistent: true)
    Application.put_env(:steinadler, :grpc_port, port, persistent: true)
    Application.ensure_started(:retry)

    local_node = Node.self()
    Logger.debug("Starting node #{inspect(local_node)}")

    Steinadler.Node.start(args)

    children = [
      {Cachex,
       [
         name: :function_calls,
         compressed: true,
         expiration:
           expiration(
             # default record expiration
             default: :timer.minutes(3),

             # how often cleanup should occur
             interval: :timer.seconds(30),

             # whether to enable lazy checking
             lazy: true
           )
       ]},
      {Registry, keys: :unique, name: Steinadler.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: Steinadler.DynamicSupervisor},
      {Steinadler.Process.Supervisor, []},
      {Steinadler.Dist.Protocol.StreamSupervisor, []},
      {GRPC.Server.Supervisor, get_grpc_options(port)},
      cluster_supervisor(args)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  defp get_grpc_options(port) do
    if Application.get_env(:steinadler, :tls) do
      cert_path = Application.get_env(:steinadler, :tls_cert_path)
      key_path = Application.get_env(:steinadler, :tls_key_path)
      cred = GRPC.Credential.new(ssl: [certfile: cert_path, keyfile: key_path])

      {Steinadler.Dist.Protocol.Endpoint, port, cred: cred}
    else
      {Steinadler.Dist.Protocol.Endpoint, port}
    end
  end

  defp cluster_supervisor(args) do
    cluster_strategy = Keyword.get(args, :cluster_strategy, :gossip)

    topologies =
      case cluster_strategy do
        :gossip ->
          get_gossip_strategy(args)

        :kubernetes ->
          get_k8s_strategy(args)

        _ ->
          Logger.warn("Invalid Topology")
      end

    if topologies && Code.ensure_compiled(Cluster.Supervisor) do
      Logger.debug("Cluster Strategy #{cluster_strategy}")

      Logger.debug("Cluster topology #{inspect(topologies)}")
      {Cluster.Supervisor, [topologies, [name: Steinadler.NodeSupervisor]]}
    end
  end

  defp get_gossip_strategy(args) do
    port = Keyword.get(args, :default_port, 4_000)

    [
      steinadler: [
        strategy: Cluster.Strategy.Gossip,
        # The function to use for connecting nodes. The node
        # name will be appended to the argument list. Optional
        connect: {Steinadler.Node, :connect, [port]},
        # The function to use for disconnecting nodes. The node
        # name will be appended to the argument list. Optional
        disconnect: {Steinadler.Node, :disconnect, [Keyword.get(args, :default_port, 4_000)]},
        # The function to use for listing nodes.
        # This function must return a list of node names. Optional
        list_nodes: {Steinadler.Node, :list, []}
      ]
    ]
  end

  defp get_k8s_strategy(args) do
    service = Keyword.get(args, :service)
    port = Keyword.get(args, :default_port, 4_000)
    application_name = Keyword.get(args, :application_name)
    polling_interval = Keyword.get(args, :polling_interval, 3_000)

    [
      steinadler: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        # The function to use for connecting nodes. The node
        # name will be appended to the argument list. Optional
        connect: {Steinadler.Node, :connect, [port]},
        # The function to use for disconnecting nodes. The node
        # name will be appended to the argument list. Optional
        disconnect: {Steinadler.Node, :disconnect, [port]},
        # The function to use for listing nodes.
        # This function must return a list of node names. Optional
        list_nodes: {Steinadler.Node, :list, []},
        config: [
          service: service,
          application_name: application_name,
          polling_interval: polling_interval
        ]
      ]
    ]
  end
end
