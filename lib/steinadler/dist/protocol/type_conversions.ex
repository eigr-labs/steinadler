defmodule Steinadler.Dist.Protocol.TypeConversions do
  alias Google.Protobuf.Any

  def convert(value) when is_binary(value),
    do: Any.new(type_url: "type.googleapis.com/string", value: value)

  def convert(value) when is_atom(value),
    do: Any.new(type_url: "type.googleapis.com/atom", value: Atom.to_string(value))

  def convert(value) when is_integer(value),
    do: Any.new(type_url: "type.googleapis.com/integer", value: Integer.to_string(value))

  def convert(value) when is_float(value),
    do: Any.new(type_url: "type.googleapis.com/float", value: Float.to_string(value))

  @spec from(Google.Protobuf.Any.t()) :: any
  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/string",
      do: value

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/atom",
      do: String.to_existing_atom(value)

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/integer" do
    {r, _} = Integer.parse(value)
    r
  end

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/float" do
    {r, _} = Float.parse(value)
    r
  end

  def from(%Any{type_url: type_url, value: _value} = _any)
      when type_url == "type.googleapis.com/struct" do
    # Todo: parse structs. Maybe using Json?
  end
end
