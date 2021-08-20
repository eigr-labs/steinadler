defmodule Steinadler.Node do
  @moduledoc """
  `Steinadler.Node`
  """

  @behaviour Steinadler.NodeBehaviour

  @impl true
  def list() do
    :ets.tab2list(:nodes)
    |> Enum.map(fn {address, _node} -> String.to_existing_atom(address) end)
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  def spawn(_address, _mod, _fun, _args) do
    :ok
  end

  @impl true
  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_address, _mod, _fun, _args, _opts) do
    :ok
  end
end
