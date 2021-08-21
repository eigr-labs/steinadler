defmodule Steinadler.NodeBehaviour do
  @type addres :: atom()

  @callback start(any) :: :ok | {:error, any()}

  @callback list() :: [atom()]

  @callback connect(addres()) :: boolean()

  @callback disconnect(atom()) :: boolean()

  @callback spawn(addres(), module(), atom(), [any()]) :: :ok | {:error, any()}

  @callback spawn(addres(), module(), atom(), [any()], Process.spawn_opts()) ::
              :ok | {:error, any()}
end
