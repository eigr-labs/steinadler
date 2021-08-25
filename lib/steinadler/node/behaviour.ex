defmodule Steinadler.NodeBehaviour do
  @type address :: atom()

  @callback start(any) :: :ok | {:error, any()}

  @callback list() :: [atom()]

  @callback connect(integer(), address()) :: boolean()

  @callback disconnect(integer(), address()) :: boolean()

  @callback spawn(address(), module(), atom(), [any()]) :: :ok | {:error, any()}

  @callback spawn(address(), module(), atom(), [any()], Process.spawn_opts()) ::
              :ok | {:error, any()}
end
