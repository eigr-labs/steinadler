defmodule Steinadler.Node.Client.SimpleNode do
  @moduledoc """

  """
  require Logger

  @behaviour Steinadler.NodeBehaviour

  import Steinadler.Dist.Protocol.TypeConversions
  alias Steinadler.Dist.Protocol.{PID, ProcessRequest}

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
    |> Enum.map(fn {address, _node} -> String.to_existing_atom(address) end)
  end

  @impl true
  @spec connect(atom()) :: boolean()
  def connect(address) do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Connecting with Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    # spawn_link(fn -> Native.register(name, fqdn, 4000) end)
    true
  end

  @impl true
  @spec disconnect(atom()) :: boolean()
  def disconnect(address) do
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
