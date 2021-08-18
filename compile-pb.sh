#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/steinadler/dist/protocol --proto_path=priv/protos/protocol/ priv/protos/protocol/dist.proto
