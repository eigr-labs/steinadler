defmodule Steinadler.Dist.Protocol.StreamServer do
  @moduledoc """

  """
  use GenServer
  require Logger

  @doc false
  def start_link(%{payload: %{pid: stream_pid}} = stream) do
    GenServer.start_link(__MODULE__, stream, name: via(stream_pid))
  end

  @impl true
  @spec init(%{:payload => %{:pid => pid}, optional(any) => any}) ::
          {:ok, %{stream_pid: pid, stream: map}}
  def init(%{payload: %{pid: stream_pid}} = stream) do
    Process.monitor(stream_pid)
    Process.flag(:trap_exit, true)

    {:ok, %{stream_pid: stream_pid, stream: stream}}
  end

  @impl true
  def handle_info({:DOWN, _, _, _, reason}, %{stream_pid: stream_pid} = state) do
    Logger.info("Stream closed with reason #{inspect(reason)} for stream #{stream_pid}")

    {:stop, :normal, state}
  end

  defp via(stream_pid) do
    {:via, Registry, {Steinadler.Registry, stream_pid}}
  end
end
