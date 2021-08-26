defmodule Steinadler.Node.Client.SimpleNode do
  @moduledoc """

  """
  require Logger
  import Steinadler.Dist.Protocol.{Util, TypeConversions}

  alias Steinadler.Node.Client.GrpcClient, as: NodeClient
  alias Steinadler.Dist.Protocol.{Data, Node, PID, ProcessRequest, Register}

  @behaviour Steinadler.NodeBehaviour

  @impl true
  @spec start(any) :: :ok
  def start(_args) do
    :ets.new(:nodes, [:named_table, :set, :public, read_concurrency: true])
    :ok
  end

  @impl true
  @spec list :: [atom()]
  def list() do
    :ets.tab2list(:nodes)
    |> Enum.map(fn {_address, node} -> String.to_existing_atom(node.address) end)
  end

  @impl true
  @spec list(any()) :: [atom()]
  def list(opts) when opts == :visible do
    others =
      :ets.tab2list(:nodes)
      |> Enum.map(fn {_address, node} -> String.to_existing_atom(node.address) end)

    [node()] ++ others
  end

  @impl true
  @spec connect(atom()) :: true
  def connect(address) do
    child = {Steinadler.Node.Client.GrpcClient, %{clients: %{}}}

    case DynamicSupervisor.start_child(Steinadler.DynamicSupervisor, child) do
      {:ok, _pid} ->
        try_connect(address)

      {:error, {:already_started, _pid}} ->
        try_connect(address)

      error ->
        Logger.error(
          "Error during connection process with address #{inspect(address)}. Details: #{
            inspect(error)
          }"
        )
    end

    true
  end

  @impl true
  @spec disconnect(atom()) :: boolean()
  def disconnect(address) do
    _port = resolve_port(address)
    [name, fqdn] = String.split(Atom.to_string(address), "@")

    Logger.debug("Disconnecting from Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    true
  end

  @impl true
  @spec resolve_port(atom()) :: integer()
  def resolve_port(address) when is_atom(address) do
    [name, _fqdn] = String.split(Atom.to_string(address), "@")
    dist_port(name)
  end

  @impl true
  def resolve_port(address) when is_binary(address) do
    [name, _fqdn] = String.split(address, "@")
    dist_port(name)
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  def spawn(address, mod, fun, args) do
    port = resolve_port(address)
    req = get_request(mod, fun, args)
    data = Data.new(action: {:request, req})
    NodeClient.send(address, port, data)
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_address, _mod, _fun, _args, _opts) do
    :ok
  end

  defp try_connect(address) do
    local_address = node()
    local_port = resolve_port(local_address)
    remote_port = resolve_port(address)

    with {:ok, _clients} <- NodeClient.connect(remote_port, address) do
      [name, _fqdn] = String.split(Atom.to_string(local_address), "@")

      node = Node.new(name: name, address: Atom.to_string(local_address), port: local_port)
      data = Data.new(action: {:register, Register.new(node: node)})
      NodeClient.send(address, remote_port, data)
    else
      error ->
        Logger.error(
          "Error during connection process with address #{inspect(address)}. Details: #{
            inspect(error)
          }"
        )
    end
  end

  defp get_request(mod, fun, args) do
    [module: _, exports: _, attributes: _, compile: _, md5: module_md5] = mod.module_info()
    function_args = %{md5: module_md5, fun: fun, args: args}
    hash = :crypto.hash(:sha, :erlang.term_to_binary(function_args)) |> Base.encode64()

    module = Atom.to_string(mod)
    function = Atom.to_string(fun)
    arguments = args |> Enum.map(&convert/1)

    pid = PID.new(pid: "#{inspect(self())}")

    ProcessRequest.new(
      source: pid,
      mod: module,
      fun: function,
      args: arguments,
      request_hash: hash
    )
  end
end
