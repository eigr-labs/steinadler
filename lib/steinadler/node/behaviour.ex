defmodule Steinadler.NodeBehaviour do
  @type address :: atom()

  @callback start(any) :: :ok | {:error, any()}

  @callback list() :: [atom()]

  @callback list(any()) :: [atom()]

  @callback connect(address()) :: boolean()

  @callback disconnect(address()) :: boolean()

  @callback resolve_port(atom()) :: integer()

  @callback spawn(address(), module(), atom(), [any()]) :: :ok | {:error, any()}

  @callback spawn(address(), module(), atom(), [any()], Process.spawn_opts()) ::
              :ok | {:error, any()}
end
