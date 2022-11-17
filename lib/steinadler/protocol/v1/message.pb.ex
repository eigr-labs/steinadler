defmodule Eigr.Steinadler.Protocol.V1.Function do
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
          json_name: "spec",
          label: :LABEL_OPTIONAL,
          name: "spec",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        }
      ],
      name: "Function",
      nested_type: [],
      oneof_decl: [],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  field :spec, 1, type: Eigr.Steinadler.Protocol.V1.Term
end
defmodule Eigr.Steinadler.Protocol.V1.Module do
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
          json_name: "name",
          label: :LABEL_OPTIONAL,
          name: "name",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_STRING,
          type_name: nil
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "spec",
          label: :LABEL_OPTIONAL,
          name: "spec",
          number: 2,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        }
      ],
      name: "Module",
      nested_type: [],
      oneof_decl: [],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  field :name, 1, type: :string
  field :spec, 2, type: Eigr.Steinadler.Protocol.V1.Term
end
defmodule Eigr.Steinadler.Protocol.V1.MFA do
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
          json_name: "module",
          label: :LABEL_OPTIONAL,
          name: "module",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Module"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "function",
          label: :LABEL_OPTIONAL,
          name: "function",
          number: 2,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Function"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "args",
          label: :LABEL_OPTIONAL,
          name: "args",
          number: 3,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        }
      ],
      name: "MFA",
      nested_type: [],
      oneof_decl: [],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  field :module, 1, type: Eigr.Steinadler.Protocol.V1.Module
  field :function, 2, type: Eigr.Steinadler.Protocol.V1.Function
  field :args, 3, type: Eigr.Steinadler.Protocol.V1.Term
end
defmodule Eigr.Steinadler.Protocol.V1.Request do
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
          json_name: "node",
          label: :LABEL_OPTIONAL,
          name: "node",
          number: 1,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_STRING,
          type_name: nil
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "function",
          label: :LABEL_OPTIONAL,
          name: "function",
          number: 2,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Function"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "mfa",
          label: :LABEL_OPTIONAL,
          name: "mfa",
          number: 3,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.MFA"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "opts",
          label: :LABEL_OPTIONAL,
          name: "opts",
          number: 4,
          oneof_index: nil,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        }
      ],
      name: "Request",
      nested_type: [],
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{__unknown_fields__: [], name: "type", options: nil}
      ],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  oneof :type, 0

  field :node, 1, type: :string
  field :function, 2, type: Eigr.Steinadler.Protocol.V1.Function, oneof: 0
  field :mfa, 3, type: Eigr.Steinadler.Protocol.V1.MFA, oneof: 0
  field :opts, 4, type: Eigr.Steinadler.Protocol.V1.Term
end
defmodule Eigr.Steinadler.Protocol.V1.Response do
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
          json_name: "pid",
          label: :LABEL_OPTIONAL,
          name: "pid",
          number: 1,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        },
        %Google.Protobuf.FieldDescriptorProto{
          __unknown_fields__: [],
          default_value: nil,
          extendee: nil,
          json_name: "reply",
          label: :LABEL_OPTIONAL,
          name: "reply",
          number: 2,
          oneof_index: 0,
          options: nil,
          proto3_optional: nil,
          type: :TYPE_MESSAGE,
          type_name: ".eigr.steinadler.protocol.v1.Term"
        }
      ],
      name: "Response",
      nested_type: [],
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{__unknown_fields__: [], name: "type", options: nil}
      ],
      options: nil,
      reserved_name: [],
      reserved_range: []
    }
  end

  oneof :type, 0

  field :pid, 1, type: Eigr.Steinadler.Protocol.V1.Term, oneof: 0
  field :reply, 2, type: Eigr.Steinadler.Protocol.V1.Term, oneof: 0
end
