defmodule Steinadler.StreamRef do
  @moduledoc """
  `StreamRef`
  """

  @type opts :: any()

  @type node_address :: atom()

  @callback sink(opts()) :: {:ok, node_address(), Flow.t()}
  @callback source(Flow.t(), opts()) :: {:ok, Flow.t()}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behavior Steinadler.StreamRef
    end
  end
end
