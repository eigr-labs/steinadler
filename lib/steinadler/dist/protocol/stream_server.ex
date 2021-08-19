defmodule Steinadler.Dist.Protocol.StreamServer do
  @moduledoc """

  """
  use GenServer
  require Logger

  alias Steinadler.Dist.Protocol.{Node, ProcessRequest}

  # Server API

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

  @impl true
  def handle_call({:request, _req}, _from, state) do
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:register, _node}, _from, state) do
    {:reply, :ok, state, :hibernate}
  end

  @impl true
  def handle_cast({:unregister, _node}, state) do
    {:stop, :normal, state}
  end

  # Client API

  @doc false
  def start_link(%{payload: %{pid: stream_pid}} = stream) do
    GenServer.start_link(__MODULE__, stream, name: via(stream_pid))
  end

  @spec forward(
          {:register, Node.t()}
          | {:unregister, Node.t()}
          | {:request, ProcessRequest.t()},
          %{:pid => any, optional(any) => any}
        ) :: any
  def forward({:register, node} = _message, stream_pid) do
    GenServer.call(via(stream_pid), {:register, node})
  end

  def forward({:unregister, node} = _message, stream_pid) do
    GenServer.cast(via(stream_pid), {:unregister, node})
  end

  def forward({:request, req} = _message, stream_pid) do
    GenServer.call(via(stream_pid), {:request, req})
  end

  defp via(stream_pid) do
    {:via, Registry, {Steinadler.Registry, stream_pid}}
  end
end
