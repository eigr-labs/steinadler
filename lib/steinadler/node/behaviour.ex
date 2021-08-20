defmodule Steinadler.NodeBehaviour do
  @callback list() :: [atom()]

  @callback spawn(atom(), module(), atom(), [any()]) :: :ok | {:error, any()}

  @callback spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) ::
              :ok | {:error, any()}
end
