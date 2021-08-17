defmodule Steinadler.TCP.RouterHandler do
  @moduledoc """
  TCP Handler
  """
  use GenServer
  require Logger

  @behaviour :ranch_protocol

  @impl true
  @spec init(any) :: {:ok, any}
  def init(state) do
    {:ok, state}
  end

  def init(ref, socket, transport) do
    Logger.debug("Starting protocol...")

    {:ok, _} = :ranch.handshake(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})

    {:ok, :waiting}
  end

  @impl true
  def handle_info({:tcp, socket, data}, state = %{socket: socket, transport: _transport}) do
    Logger.debug("Received data #{inspect(data)}")

    # TODO: Do something with data
    # transport.send(socket, data)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, state = %{socket: socket, transport: transport}) do
    Logger.debug("Closing connection...")
    transport.close(socket)
    {:stop, :normal, state}
  end

  @impl true
  @spec start_link(any, any, any) :: {:ok, pid}
  def start_link(ref, socket, transport) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end
end
