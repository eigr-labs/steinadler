defmodule Steinadler.Dist.Protocol.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Logger.Server)

  services = [
    Steinadler.Dist.Protocol.RouterServer
  ]

  run(services)
end
