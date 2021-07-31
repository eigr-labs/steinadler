defmodule Steinadler do
  @moduledoc """
  `Steinadler`.
  """
  alias Steinadler.Native

  @spec bind(String.t(), integer()) :: boolean()
  def bind(address, port) do
    Native.bind(address, port)
  end

  @spec connect(String.t(), String.t(), integer()) :: boolean()
  def connect(name, address, port) do
    Native.connect(name, address, port)
  end

  @spec disconnect(String.t()) :: boolean()
  def disconnect(name) do
    Native.disconnect(name)
  end
end
