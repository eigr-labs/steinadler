defmodule Steinadler.Process do
  @moduledoc """
  `Steinadler.Process`
  """

  @behaviour Steinadler.ProcessBehaviour

  @impl true
  @spec spawn(any, module(), atom(), [any()]) :: :ok
  def spawn(_atom, _mod, _fun, _args) do
    :ok
  end

  @impl true
  @spec spawn(any, module(), atom(), [any()], Process.spawn_opts()) :: :ok
  def spawn(_atom, _mod, _fun, _args, _opts) do
    :ok
  end
end
