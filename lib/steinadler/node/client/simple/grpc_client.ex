defmodule Steinadler.Node.Client.GrpcClient do
  @moduledoc false
  use GenServer
  require Logger

  alias Steinadler.Dist.Protocol.{Data, ProcessRequest, Register, Token}
  alias Steinadler.Dist.Protocol.DistributionProtocol.Stub, as: DistributionService

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:connect, address}, _from, %{clients: clients} = state) do
    token = Token.create(%{"sub" => address})

    case GRPC.Stub.connect(address,
           headers: [{"authorization", token}],
           adapter_opts: %{http2_opts: %{keepalive: 10000}}
         ) do
      {:ok, %GRPC.Channel{adapter_payload: %{conn_pid: connection_pid}} = channel} ->
        stream = DistributionService.handle(channel, compressor: GRPC.Compressor.Gzip)
        Process.monitor(connection_pid)

        clients = Map.put(clients, address, {channel, stream})
        state = %{state | clients: clients}

        spawn(fn ->
          Logger.debug("Steinadler Cluster waiting for events...")
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
  def handle_call(
        {:send, address, port, data},
        _from,
        %{clients: clients} = state
      ) do
    [_name, fqdn] = String.split(Atom.to_string(address), "@")

    remote = "#{fqdn}:#{port}"
    IO.inspect(remote, label: "Vaiiiiii")

    {_channel, stream} = Map.get(clients, remote)

    GRPC.Stub.send_request(stream, data)
    {:reply, [], state}
  end

  @impl true
  def handle_call(
        {:send, address, port, %Data{action: {:request, %ProcessRequest{}}} = data},
        _from,
        %{clients: clients} = state
      ) do
    [_name, fqdn] = String.split(Atom.to_string(address), "@")

    remote = "#{fqdn}:#{port}"
    {_channel, stream} = Map.get(clients, remote)
    GRPC.Stub.send_request(stream, data)
    {:reply, [], state}
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def connect(port, address) when (is_atom(address) and not is_nil(address)) or address != "" do
    [name, fqdn] = String.split(Atom.to_string(address), "@")
    Logger.debug("Connecting with Node: #{inspect(name)}. On Address: #{inspect(fqdn)}:#{port}")
    GenServer.call(__MODULE__, {:connect, "#{fqdn}:#{port}"})
  end

  def send(address, port, data), do: GenServer.call(__MODULE__, {:send, address, port, data})

  defp handle_result(elem) do
    Logger.debug("Received message #{inspect(elem)}")
  end
end
