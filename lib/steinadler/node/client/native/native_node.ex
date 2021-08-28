defmodule Steinadler.Node.Client.NativeNode do
  @moduledoc """

  """
  require Logger

  import Steinadler.Dist.Protocol.Util

  alias Steinadler.Node.Client.Native

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
    |> Enum.map(fn {address, _node} -> String.to_existing_atom(address) end)
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
  @spec connect(atom()) :: boolean()
  def connect(address) do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Connecting with Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    spawn_link(fn -> Native.bind(name, fqdn, resolve_port(address)) end)
    true
  end

  @impl true
  @spec disconnect(atom()) :: boolean()
  def disconnect(address) do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Disconnecting from Node: #{inspect(name)}. On Address: #{inspect(fqdn)}")
    Native.unbind(name)
    true
  end

  @impl true
  @spec resolve_port(atom()) :: integer()
  def resolve_port(address) when is_atom(address) do
    [name, _fqdn] = String.split(Atom.to_string(address), "@")
    dist_port(name)
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  def spawn(_address, _mod, _fun, _args) do
    Native.send("127.0.0.1", 4001, "Teste")
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_address, _mod, _fun, _args, _opts) do
    :ok
  end
end
