defmodule Steinadler.Node.Client.Native do
  @moduledoc """
  Native bindings
  """
  use Rustler,
    otp_app: :steinadler,
    crate: :steinadler

  @spec bind(String.t(), String.t(), integer()) :: boolean()
  def bind(_name, _address, _port), do: error()

  @spec unbind(String.t()) :: boolean()
  def unbind(_name), do: error()

  @spec send(String.t(), integer(), String.t()) :: boolean()
  def send(_address, _port, _data), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
