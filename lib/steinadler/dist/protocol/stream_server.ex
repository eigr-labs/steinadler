defmodule Steinadler.Dist.Protocol.StreamServer do
  @moduledoc """

  """
  use GenServer
  require Logger

  alias Steinadler.Dist.Protocol.{Node, ProcessRequest}

  # Server API

  @impl true
  def init(%{address: address, stream: %{payload: %{pid: stream_pid} = stream}} = _args) do
    Process.monitor(stream_pid)
    Process.flag(:trap_exit, true)

    {:ok, %{address: address, stream_pid: stream_pid, stream: stream}}
  end

  @impl true
  def handle_info({:DOWN, _, _, _, reason}, %{address: address, stream_pid: stream_pid} = state) do
    Logger.warn(
      "Stream closed with reason #{inspect(reason)} for stream #{inspect(stream_pid)} on Address #{
        inspect(address)
      }"
    )

    {:stop, :normal, state}
  end

  @impl true
  def handle_call({:request, %ProcessRequest{} = req, _stream}, _from, state) do
    Logger.debug("Received request: #{inspect(req)}")

    with {:ok, res} <- Steinadler.Process.handle(req) do
      # TODO: Generate ProcessResponse with success type and send to the caller
      Logger.debug("Success on execute function. Response: #{inspect(res)}")
    else
      {:error, cause} ->
        # TODO: Generate ProcessResponse with error type and send to the caller
        Logger.debug("Error on execute function. Cause: #{inspect(cause)}")
    end

    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:register, %Node{} = node, _stream}, _from, state) do
    Logger.debug("Registering node: #{inspect(node)}")
    :ets.insert(:nodes, {node.address, node})
    {:reply, :ok, state, :hibernate}
  end

  @impl true
  def handle_cast({:unregister, %Node{} = node, _stream}, state) do
    Logger.debug("Unregistering node: #{inspect(node)}")
    key = node.address

    case :ets.lookup(:nodes, key) do
      [{^key, _node}] -> :ets.delete(:nodes, key)
      [] -> Logger.warn("Nothing to do with key #{inspect(key)}")
    end

    {:stop, :normal, state}
  end

  # Client API

  @doc false
  def start_link(%{address: address} = args) do
    GenServer.start_link(__MODULE__, args, name: via(address))
  end

  @spec forward({:register, Node.t(), any} | {:request, any, any} | {:unregister, any, any}, any) ::
          any
  def forward({:register, node, stream} = _message, address) do
    GenServer.call(via(address), {:register, node, stream})
  end

  def forward({:unregister, node, stream} = _message, address) do
    GenServer.cast(via(address), {:unregister, node, stream})
  end

  def forward({:request, req, stream} = _message, address) do
    GenServer.call(via(address), {:request, req, stream})
  end

  defp via(address), do: {:via, Registry, {Steinadler.Registry, {__MODULE__, address}}}
end
