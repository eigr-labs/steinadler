defmodule Steinadler.ProcessBehaviour do
  @callback spawn(atom(), module(), atom(), [any()]) :: :ok | {:error, any()}

  @callback spawn(atom(), module(), atom(), [any()], Process.spawn_opts()) ::
              :ok | {:error, any()}
end
