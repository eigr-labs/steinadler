defmodule Steinadler.Node.Client.Native do
  @moduledoc """
  Native bindings
  """
  use Rustler,
    otp_app: :steinadler,
    crate: :steinadler

  @spec register(String.t(), String.t(), integer()) :: boolean()
  def register(_name, _address, _port), do: error()

  @spec unregister(String.t()) :: boolean()
  def unregister(_name), do: error()

  @spec start_node(String.t(), integer()) :: boolean()
  def start_node(_address, _port), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
