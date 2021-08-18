defmodule Steinadler do
  @moduledoc """
  `Steinadler`.
  """
  use Supervisor
  require Logger

  @impl true
  def init(args) do
    Application.put_env(:grpc, :start_server, true, persistent: true)
    port = Keyword.get(args, :default_port, 4_000)
    local_node = Node.self()
    Logger.debug("Starting node #{inspect(local_node)}")

    children = [
      {Registry, keys: :unique, name: Steinadler.Registry},
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
          get_dns_strategy(args)

        _ ->
          Logger.warn("Invalid Topology")
      end

    if topologies && Code.ensure_compiled(Cluster.Supervisor) do
      Logger.debug("Cluster Strategy #{cluster_strategy}")

      Logger.debug("Cluster topology #{inspect(topologies)}")
      {Cluster.Supervisor, [topologies, [name: Steinadler.NodeSupervisor]]}
    end
  end

  defp get_gossip_strategy(_args),
    do: [
      steinadler: [
        strategy: Cluster.Strategy.Gossip,
        # The function to use for connecting nodes. The node
        # name will be appended to the argument list. Optional
        connect: {Steinadler.LocalNode, :register, []},
        # The function to use for disconnecting nodes. The node
        # name will be appended to the argument list. Optional
        disconnect: {Steinadler.LocalNode, :unregister, []},
        # The function to use for listing nodes.
        # This function must return a list of node names. Optional
        list_nodes: {:erlang, :nodes, [:connected]}
      ]
    ]

  defp get_dns_strategy(args) do
    service = Keyword.get(args, :service)
    application_name = Keyword.get(args, :application_name)
    polling_interval = Keyword.get(args, :polling_interval, 3_000)

    [
      steinadler: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
        # The function to use for connecting nodes. The node
        # name will be appended to the argument list. Optional
        connect: {Steinadler.LocalNode, :register, []},
        # The function to use for disconnecting nodes. The node
        # name will be appended to the argument list. Optional
        disconnect: {Steinadler.LocalNode, :unregister, []},
        # The function to use for listing nodes.
        # This function must return a list of node names. Optional
        list_nodes: {:erlang, :nodes, [:connected]},
        config: [
          service: service,
          application_name: application_name,
          polling_interval: polling_interval
        ]
      ]
    ]
  end

  defmodule LocalNode do
    require Logger
    alias Steinadler.Native

    @spec start_node(String.t(), String.t(), integer()) :: any()
    def start_node(_name, address, port),
      do: spawn_link(fn -> Native.start_node(address, port) end)

    @spec register(atom()) :: boolean()
    def register(address) do
      [name, fqdn] = String.split(Atom.to_string(address), "@")
      Logger.debug("Connecting with Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
      spawn_link(fn -> Native.register(name, fqdn, 4000) end)
      true
    end

    @spec unregister(atom()) :: boolean()
    def unregister(address) do
      [name, fqdn] = String.split(Atom.to_string(address), "@")
      Logger.debug("Disconnecting from Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
      Native.unregister(name)
      true
    end
  end
end
