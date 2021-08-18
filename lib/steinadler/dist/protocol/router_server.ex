defmodule Steinadler.Dist.Protocol.RouterServer do
  use GRPC.Server, service: Steinadler.Dist.Protocol.DistributionProtocol.Service
  require Logger

  @spec handle(Steinadler.Dist.Protocol.Data.t(), GRPC.Server.Stream.t()) :: any()
  def handle(request, stream) do
    with {:ok, _pid} <- Steinadler.Dist.Protocol.StreamSupervisor.add_stream_to_supervisor(stream) do
      Stream.each(request, fn _data ->
        nil
      end)
      |> Stream.run()
    end

    :ok
  end
end
