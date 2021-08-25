defmodule Steinadler.Node do
  @moduledoc """
  `Steinadler.Node`
  """
  use Injectx

  inject(Steinadler.NodeBehaviour)

  @spec start(any) :: :ok
  defdelegate start(args), to: NodeBehaviour

  @spec list :: [atom()]
  defdelegate list(), to: NodeBehaviour

  @spec list(any()) :: [atom()]
  defdelegate list(opts), to: NodeBehaviour

  @spec connect(integer(), atom()) :: boolean()
  defdelegate connect(port, address), to: NodeBehaviour

  @spec disconnect(integer(), atom()) :: boolean()
  defdelegate disconnect(port, address), to: NodeBehaviour

  @spec self() :: atom()
  defdelegate self(), to: NodeBehaviour

  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  defdelegate spawn(address, mod, fun, args), to: NodeBehaviour

  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  defdelegate spawn(address, mod, fun, args, opts), to: NodeBehaviour
end
