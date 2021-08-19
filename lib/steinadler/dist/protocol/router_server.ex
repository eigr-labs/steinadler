defmodule Steinadler.Dist.Protocol.RouterServer do
  use GRPC.Server,
    service: Steinadler.Dist.Protocol.DistributionProtocol.Service,
    compressors: [GRPC.Compressor.Gzip]

  require Logger

  alias Steinadler.Dist.Protocol.{Data, Register, StreamServer}

  @spec handle(Steinadler.Dist.Protocol.Data.t(), GRPC.Server.Stream.t()) :: any()
  def handle(request, stream) do
    with %{authorization: token} <- GRPC.Stream.get_headers(stream),
         {:ok, _} <- is_authenticated?(token),
         {:ok, _pid} <- Steinadler.Dist.Protocol.StreamSupervisor.add_stream_to_supervisor(stream) do
      Stream.each(request, fn %Data{action: req} ->
        route(req, stream)
      end)
      |> Stream.run()
    end

    :ok
  end

  defp is_authenticated?(_token) do
    {:ok, :authorized}
  end

  def route({:register, %Register{node: node}} = _message, %{pid: stream_pid} = _stream) do
    StreamServer.forward({:register, node}, stream_pid)
  end

  def route({:unregister, %Register{node: node}} = _message, %{pid: stream_pid} = _stream) do
    StreamServer.forward({:unregister, node}, stream_pid)
  end

  def route({:request, req} = _message, %{pid: stream_pid} = _stream) do
    StreamServer.forward({:request, req}, stream_pid)
  end
end
