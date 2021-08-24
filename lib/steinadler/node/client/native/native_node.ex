defmodule Steinadler.Node.Client.NativeNode do
  @moduledoc """

  """
  require Logger

  @behaviour Steinadler.NodeBehaviour

  alias Steinadler.Node.Client.Native

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
    spawn_link(fn -> Native.register(name, fqdn, 4000) end)
    true
  end

  @impl true
  @spec disconnect(atom()) :: boolean()
  def disconnect(address) do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Disconnecting from Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    Native.unregister(name)
    true
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  def spawn(_address, _mod, _fun, _args) do
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_address, _mod, _fun, _args, _opts) do
    :ok
  end
end
