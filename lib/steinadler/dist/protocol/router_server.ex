defmodule Steinadler.Dist.Protocol.RouterServer do
  use GRPC.Server,
    service: Steinadler.Dist.Protocol.DistributionProtocol.Service,
    compressors: [GRPC.Compressor.Gzip]

  require Logger

  alias Steinadler.Dist.Protocol.{Data, ProcessRequest, Register, StreamServer, Token}

  @spec handle(Steinadler.Dist.Protocol.Data.t(), GRPC.Server.Stream.t()) :: any()
  def handle(request, stream) do
    with headers when is_map(headers) <- GRPC.Stream.get_headers(stream),
         token when not is_nil(token) <- Map.get(headers, "authorization"),
         {:ok, address} <- is_authenticated?(token),
         {:ok, _pid} <-
           Steinadler.Dist.Protocol.StreamSupervisor.add_stream_to_supervisor(%{
             address: address,
             stream: stream
           }) do
      Stream.each(request, fn %Data{action: req} ->
        Logger.debug("Received request #{inspect(req)}")
        route(req, stream, address)
      end)
      |> Stream.run()
    else
      unknown ->
        Logger.warn("Failed to process request #{inspect(request)}. Reason: #{inspect(unknown)}")
    end

    Steinadler.Dist.Protocol.ProcessResponse.new()
  end

  defp is_authenticated?(token) do
    case Token.validate(token) do
      {:ok, %{"iss" => "Steinadler", "sub" => address}} ->
        {:ok, address}

      _ ->
        {:error, :unauthenticated}
    end

    {:ok, :authorized}
  end

  def route({:request, %ProcessRequest{} = req} = _message, stream, address) do
    StreamServer.forward({:request, req, stream}, address)
  end

  def route({:register, %Register{node: node}} = _message, stream, address) do
    StreamServer.forward({:register, node, stream}, address)
  end

  def route(
        {:unregister, %Register{node: node}} = _message,
        stream,
        address
      ) do
    StreamServer.forward({:unregister, node, stream}, address)
  end
end
