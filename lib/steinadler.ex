defmodule Steinadler do
  @moduledoc """
  `Steinadler`.
  """
  alias Steinadler.Native

  @spec bind(String.t(), integer()) :: any()
  def bind(address, port), do: spawn(fn -> Native.bind(address, port) end)

  @spec connect(String.t(), String.t(), integer()) :: any()
  def connect(name, address, port), do: spawn(fn -> Native.connect(name, address, port) end)

  @spec disconnect(String.t()) :: boolean()
  def disconnect(name) do
    Native.disconnect(name)
  end
end
