defmodule Steinadler.Dist.Protocol.TypeConversions do
  alias Google.Protobuf.Any

  def convert(value) when is_binary(value) do
    Any.new(type_url: "type.googleapis.com/string", value: value)
  end

  def convert(value) when is_atom(value) do
    Any.new(type_url: "type.googleapis.com/atom", value: Atom.to_string(value))
  end

  def convert(value) when is_integer(value) do
    Any.new(type_url: "type.googleapis.com/integer", value: Integer.to_string(value))
  end

  def convert(value) when is_float(value) do
    Any.new(type_url: "type.googleapis.com/float", value: Float.to_string(value))
  end

  @spec from(Google.Protobuf.Any.t()) :: any
  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/string" do
    value
  end

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/atom" do
    String.to_existing_atom(value)
  end

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/integer" do
    Integer.parse(value)
  end

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/float" do
    Float.parse(value)
  end

  def from(%Any{type_url: type_url, value: _value} = _any)
      when type_url == "type.googleapis.com/struct" do
    # Todo: parse structs
  end
end
