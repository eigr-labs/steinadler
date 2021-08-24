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

  @spec connect(atom()) :: boolean()
  defdelegate connect(address), to: NodeBehaviour

  @spec disconnect(atom()) :: boolean()
  defdelegate disconnect(address), to: NodeBehaviour

  @spec spawn(atom(), module(), atom(), [any()]) :: :ok
  defdelegate spawn(address, mod, fun, args), to: NodeBehaviour

  @spec spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) :: :ok
  defdelegate spawn(address, mod, fun, args, opts), to: NodeBehaviour
end
