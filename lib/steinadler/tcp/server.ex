defmodule Steinadler.TCP.Server do
  @moduledoc """
  TCP Server for handler connections
  """
  use GenServer

  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  def start_link(_opts) do
    opts = [port: 8000]

    {:ok, _} =
      :ranch.start_listener(__MODULE__, :ranch_tcp, opts, Steinadler.TCP.RouterHandler, [])
  end
end
