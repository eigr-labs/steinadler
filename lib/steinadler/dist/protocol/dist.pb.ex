defmodule Steinadler.Dist.Protocol.Result do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :OK | :ERROR
  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.EnumDescriptorProto.decode(
      <<10, 6, 82, 101, 115, 117, 108, 116, 18, 6, 10, 2, 79, 75, 16, 0, 18, 9, 10, 5, 69, 82, 82,
        79, 82, 16, 1>>
    )
  end

  field :OK, 0
  field :ERROR, 1
end

defmodule Steinadler.Dist.Protocol.Node do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          address: String.t(),
          port: integer
        }
  defstruct [:name, :address, :port]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 4, 78, 111, 100, 101, 18, 18, 10, 4, 110, 97, 109, 101, 24, 1, 32, 1, 40, 9, 82, 4,
        110, 97, 109, 101, 18, 24, 10, 7, 97, 100, 100, 114, 101, 115, 115, 24, 2, 32, 1, 40, 9,
        82, 7, 97, 100, 100, 114, 101, 115, 115, 18, 18, 10, 4, 112, 111, 114, 116, 24, 3, 32, 1,
        40, 5, 82, 4, 112, 111, 114, 116>>
    )
  end

  field :name, 1, type: :string
  field :address, 2, type: :string
  field :port, 3, type: :int32
end

defmodule Steinadler.Dist.Protocol.Register do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          node: Steinadler.Dist.Protocol.Node.t() | nil
        }
  defstruct [:node]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 8, 82, 101, 103, 105, 115, 116, 101, 114, 18, 50, 10, 4, 110, 111, 100, 101, 24, 1,
        32, 1, 40, 11, 50, 30, 46, 115, 116, 101, 105, 110, 97, 100, 108, 101, 114, 46, 100, 105,
        115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 78, 111, 100, 101, 82, 4, 110,
        111, 100, 101>>
    )
  end

  field :node, 1, type: Steinadler.Dist.Protocol.Node
end

defmodule Steinadler.Dist.Protocol.PID do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pid: String.t()
        }
  defstruct [:pid]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 3, 80, 73, 68, 18, 16, 10, 3, 112, 105, 100, 24, 1, 32, 1, 40, 9, 82, 3, 112, 105,
        100>>
    )
  end

  field :pid, 1, type: :string
end

defmodule Steinadler.Dist.Protocol.SpawnOpts do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          opts: [String.t()]
        }
  defstruct [:opts]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 9, 83, 112, 97, 119, 110, 79, 112, 116, 115, 18, 18, 10, 4, 111, 112, 116, 115, 24, 1,
        32, 3, 40, 9, 82, 4, 111, 112, 116, 115>>
    )
  end

  field :opts, 1, repeated: true, type: :string
end

defmodule Steinadler.Dist.Protocol.ProcessRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          source: Steinadler.Dist.Protocol.PID.t() | nil,
          opts: Steinadler.Dist.Protocol.SpawnOpts.t() | nil,
          mod: String.t(),
          fun: String.t(),
          args: [Google.Protobuf.Any.t()],
          async: boolean,
          request_hash: String.t()
        }
  defstruct [:source, :opts, :mod, :fun, :args, :async, :request_hash]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 14, 80, 114, 111, 99, 101, 115, 115, 82, 101, 113, 117, 101, 115, 116, 18, 53, 10, 6,
        115, 111, 117, 114, 99, 101, 24, 1, 32, 1, 40, 11, 50, 29, 46, 115, 116, 101, 105, 110,
        97, 100, 108, 101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108,
        46, 80, 73, 68, 82, 6, 115, 111, 117, 114, 99, 101, 18, 55, 10, 4, 111, 112, 116, 115, 24,
        2, 32, 1, 40, 11, 50, 35, 46, 115, 116, 101, 105, 110, 97, 100, 108, 101, 114, 46, 100,
        105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 83, 112, 97, 119, 110, 79,
        112, 116, 115, 82, 4, 111, 112, 116, 115, 18, 16, 10, 3, 109, 111, 100, 24, 3, 32, 1, 40,
        9, 82, 3, 109, 111, 100, 18, 16, 10, 3, 102, 117, 110, 24, 4, 32, 1, 40, 9, 82, 3, 102,
        117, 110, 18, 40, 10, 4, 97, 114, 103, 115, 24, 5, 32, 3, 40, 11, 50, 20, 46, 103, 111,
        111, 103, 108, 101, 46, 112, 114, 111, 116, 111, 98, 117, 102, 46, 65, 110, 121, 82, 4,
        97, 114, 103, 115, 18, 20, 10, 5, 97, 115, 121, 110, 99, 24, 6, 32, 1, 40, 8, 82, 5, 97,
        115, 121, 110, 99, 18, 33, 10, 12, 114, 101, 113, 117, 101, 115, 116, 95, 104, 97, 115,
        104, 24, 7, 32, 1, 40, 9, 82, 11, 114, 101, 113, 117, 101, 115, 116, 72, 97, 115, 104>>
    )
  end

  field :source, 1, type: Steinadler.Dist.Protocol.PID
  field :opts, 2, type: Steinadler.Dist.Protocol.SpawnOpts
  field :mod, 3, type: :string
  field :fun, 4, type: :string
  field :args, 5, repeated: true, type: Google.Protobuf.Any
  field :async, 6, type: :bool
  field :request_hash, 7, type: :string
end

defmodule Steinadler.Dist.Protocol.ProcessResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          source: Steinadler.Dist.Protocol.PID.t() | nil,
          result: Steinadler.Dist.Protocol.Result.t()
        }
  defstruct [:source, :result]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 15, 80, 114, 111, 99, 101, 115, 115, 82, 101, 115, 112, 111, 110, 115, 101, 18, 53,
        10, 6, 115, 111, 117, 114, 99, 101, 24, 1, 32, 1, 40, 11, 50, 29, 46, 115, 116, 101, 105,
        110, 97, 100, 108, 101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111,
        108, 46, 80, 73, 68, 82, 6, 115, 111, 117, 114, 99, 101, 18, 56, 10, 6, 114, 101, 115,
        117, 108, 116, 24, 2, 32, 1, 40, 14, 50, 32, 46, 115, 116, 101, 105, 110, 97, 100, 108,
        101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 82, 101,
        115, 117, 108, 116, 82, 6, 114, 101, 115, 117, 108, 116>>
    )
  end

  field :source, 1, type: Steinadler.Dist.Protocol.PID
  field :result, 2, type: Steinadler.Dist.Protocol.Result, enum: true
end

defmodule Steinadler.Dist.Protocol.Data do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          action: {atom, any}
        }
  defstruct [:action]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 4, 68, 97, 116, 97, 18, 64, 10, 8, 114, 101, 103, 105, 115, 116, 101, 114, 24, 1, 32,
        1, 40, 11, 50, 34, 46, 115, 116, 101, 105, 110, 97, 100, 108, 101, 114, 46, 100, 105, 115,
        116, 46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 82, 101, 103, 105, 115, 116, 101, 114,
        72, 0, 82, 8, 114, 101, 103, 105, 115, 116, 101, 114, 18, 68, 10, 10, 117, 110, 114, 101,
        103, 105, 115, 116, 101, 114, 24, 2, 32, 1, 40, 11, 50, 34, 46, 115, 116, 101, 105, 110,
        97, 100, 108, 101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108,
        46, 82, 101, 103, 105, 115, 116, 101, 114, 72, 0, 82, 10, 117, 110, 114, 101, 103, 105,
        115, 116, 101, 114, 18, 68, 10, 7, 114, 101, 113, 117, 101, 115, 116, 24, 3, 32, 1, 40,
        11, 50, 40, 46, 115, 116, 101, 105, 110, 97, 100, 108, 101, 114, 46, 100, 105, 115, 116,
        46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 80, 114, 111, 99, 101, 115, 115, 82, 101,
        113, 117, 101, 115, 116, 72, 0, 82, 7, 114, 101, 113, 117, 101, 115, 116, 18, 71, 10, 8,
        114, 101, 115, 112, 111, 110, 115, 101, 24, 4, 32, 1, 40, 11, 50, 41, 46, 115, 116, 101,
        105, 110, 97, 100, 108, 101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99,
        111, 108, 46, 80, 114, 111, 99, 101, 115, 115, 82, 101, 115, 112, 111, 110, 115, 101, 72,
        0, 82, 8, 114, 101, 115, 112, 111, 110, 115, 101, 66, 8, 10, 6, 97, 99, 116, 105, 111,
        110>>
    )
  end

  oneof :action, 0
  field :register, 1, type: Steinadler.Dist.Protocol.Register, oneof: 0
  field :unregister, 2, type: Steinadler.Dist.Protocol.Register, oneof: 0
  field :request, 3, type: Steinadler.Dist.Protocol.ProcessRequest, oneof: 0
  field :response, 4, type: Steinadler.Dist.Protocol.ProcessResponse, oneof: 0
end

defmodule Steinadler.Dist.Protocol.DistributionProtocol.Service do
  @moduledoc false
  use GRPC.Service, name: "steinadler.dist.protocol.DistributionProtocol"

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.ServiceDescriptorProto.decode(
      <<10, 20, 68, 105, 115, 116, 114, 105, 98, 117, 116, 105, 111, 110, 80, 114, 111, 116, 111,
        99, 111, 108, 18, 81, 10, 6, 72, 97, 110, 100, 108, 101, 18, 30, 46, 115, 116, 101, 105,
        110, 97, 100, 108, 101, 114, 46, 100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111,
        108, 46, 68, 97, 116, 97, 26, 30, 46, 115, 116, 101, 105, 110, 97, 100, 108, 101, 114, 46,
        100, 105, 115, 116, 46, 112, 114, 111, 116, 111, 99, 111, 108, 46, 68, 97, 116, 97, 34, 3,
        136, 2, 0, 40, 1, 48, 1>>
    )
  end

  rpc :Handle, stream(Steinadler.Dist.Protocol.Data), stream(Steinadler.Dist.Protocol.Data)
end

defmodule Steinadler.Dist.Protocol.DistributionProtocol.Stub do
  @moduledoc false
  use GRPC.Stub, service: Steinadler.Dist.Protocol.DistributionProtocol.Service
end
