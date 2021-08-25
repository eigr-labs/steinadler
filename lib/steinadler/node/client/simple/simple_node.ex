defmodule Steinadler.Node.Client.SimpleNode do
  @moduledoc """

  """
  require Logger
  import Steinadler.Dist.Protocol.TypeConversions

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
  @spec connect(integer(), atom()) :: true
  def connect(port, address) do
    child = {Steinadler.Node.Client.GrpcClient, %{clients: %{}}}

    case DynamicSupervisor.start_child(Steinadler.DynamicSupervisor, child) do
      {:ok, _pid} ->
        with {:ok, _clients} <- NodeClient.connect(port, address) do
          [name, _fqdn] = String.split(Atom.to_string(address), "@")
          node = Node.new(name: name, address: Atom.to_string(address), port: port)
          data = Data.new(action: {:register, Register.new(node: node)})
          NodeClient.send(address, data)
        else
          error ->
            Logger.error(
              "Error during connection process with address #{inspect(address)}. Details: #{
                inspect(error)
              }"
            )
        end

      _ ->
        nil
    end

    true
  end

  @impl true
  @spec disconnect(integer(), atom()) :: boolean()
  def disconnect(_port, address) do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Disconnecting from Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    # Native.unregister(name)
    true
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  def spawn(_address, mod, fun, args) do
    _req = get_request(mod, fun, args)
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_address, _mod, _fun, _args, _opts) do
    :ok
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
