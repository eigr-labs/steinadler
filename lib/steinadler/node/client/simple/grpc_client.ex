defmodule Steinadler.Node.Client.GrpcClient do
  @moduledoc false
  use GenServer
  require Logger

  alias Steinadler.Dist.Protocol.DistributionProtocol.Stub, as: DistributionService

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:connect, address}, _from, %{clients: clients} = state) do
    case GRPC.Stub.connect(address,
           interceptors: [GRPC.Logger.Client],
           adapter_opts: %{http2_opts: %{keepalive: 10000}}
         ) do
      {:ok, %GRPC.Channel{adapter_payload: %{conn_pid: connection_pid}} = channel} ->
        stream = DistributionService.handle(channel, compressor: GRPC.Compressor.Gzip)

        Process.monitor(connection_pid)
        IO.inspect(channel, label: "Channel ->")
        IO.inspect(stream, label: "Stream ->")

        clients = Map.put(clients, address, {channel, stream})
        state = %{state | clients: clients}

        spawn(fn ->
          {:ok, result_stream} = GRPC.Stub.recv(stream, timeout: :infinity)

          Stream.each(result_stream, fn elem -> handle_result(elem) end)
          |> Stream.run()
        end)

        {:reply, {:ok, clients}, state}

      error ->
        Logger.error("Error during connection #{inspect(error)}")
        {:reply, {:error, error}, state}
    end
  end

  @impl true
  def handle_call({:send, address, data}, _from, %{clients: clients} = state) do
    {_channel, stream} = Map.get(clients, address)
    GRPC.Stub.send_request(stream, data)
    {:reply, [], state}
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def connect(address), do: GenServer.call(__MODULE__, {:connect, address})

  defp handle_result(elem) do
    Logger.debug("Received message #{inspect(elem)}")
  end
end
