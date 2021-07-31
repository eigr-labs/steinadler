defmodule Steinadler do
  @moduledoc """
  Documentation for `Steinadler`.
  """
  use Rustler,
    otp_app: :steinadler,
    crate: :steinadler

  @spec bind(String.t(), integer()) :: boolean()
  def bind(_address, _port), do: error()

  @spec connect(String.t(), String.t(), integer()) :: boolean()
  def connect(_name, _address, _port), do: error()

  @spec disconnect(String.t()) :: boolean()
  def disconnect(_name), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
