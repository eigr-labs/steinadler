defmodule Eigr.Steinadler.Protocol.V1.NodeUp do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      __unknown_fields__: [],
      enum_type: [],
      extension: [],
      extension_range: [],
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "nodeName",
          label: :LABEL_OPTIONAL,
          name: "node_name",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_STRING,
          type_name: nil
        }
      ],
      name: "NodeUp",
      nested_type: [],
      oneof_decl: [],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  field :node_name, 1, type: :string, json_name: "nodeName"
end
defmodule Eigr.Steinadler.Protocol.V1.NodeDown do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      __unknown_fields__: [],
      enum_type: [],
      extension: [],
      extension_range: [],
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "nodeName",
          label: :LABEL_OPTIONAL,
          name: "node_name",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_STRING,
          type_name: nil
        }
      ],
      name: "NodeDown",
      nested_type: [],
      oneof_decl: [],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  field :node_name, 1, type: :string, json_name: "nodeName"
end
defmodule Eigr.Steinadler.Protocol.V1.System do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.10.0", syntax: :proto3

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      __unknown_fields__: [],
      enum_type: [],
      extension: [],
      extension_range: [],
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "nodeUp",
          label: :LABEL_OPTIONAL,
          name: "node_up",
          number: 2,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.NodeUp"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "nodeDown",
          label: :LABEL_OPTIONAL,
          name: "node_down",
          number: 3,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.NodeDown"
        }
      ],
      name: "System",
      nested_type: [],
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          __unknown_fields__: [],
          name: "message",
          options: nil
        }
      ],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  oneof :message, 0

  field :node_up, 2, type: Eigr.Steinadler.Protocol.V1.NodeUp, json_name: "nodeUp", oneof: 0
  field :node_down, 3, type: Eigr.Steinadler.Protocol.V1.NodeDown, json_name: "nodeDown", oneof: 0
end
