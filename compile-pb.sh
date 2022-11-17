#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/steinadler/protocol/v1 --proto_path=priv/protos/eigr/steinadler/protocol/v1 priv/protos/eigr/steinadler/protocol/v1/term.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/steinadler/protocol/v1 --proto_path=priv/protos/eigr/steinadler/protocol/v1 priv/protos/eigr/steinadler/protocol/v1/system.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/steinadler/protocol/v1 --proto_path=priv/protos/eigr/steinadler/protocol/v1 priv/protos/eigr/steinadler/protocol/v1/message.proto
