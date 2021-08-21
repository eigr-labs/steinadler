defmodule Steinadler.Dist.Protocol.TypeConversions do
  alias Google.Protobuf.Any

  def convert(value) when is_binary(value),
    do: Any.new(type_url: "type.googleapis.com/string", value: value)

  def convert(value) when is_atom(value),
    do: Any.new(type_url: "type.googleapis.com/atom", value: Atom.to_string(value))

  def convert(value) when is_boolean(value),
    do: Any.new(type_url: "type.googleapis.com/boolean", value: Kernel.to_string(value))

  def convert(value) when is_integer(value),
    do: Any.new(type_url: "type.googleapis.com/integer", value: Integer.to_string(value))

  def convert(value) when is_float(value),
    do: Any.new(type_url: "type.googleapis.com/float", value: Float.to_string(value))

  def convert(value) when is_struct(value) do
    type_url = "type.googleapis.com/struct+json;#{value.__struct__}"
    Any.new(type_url: type_url, value: Poison.encode!(value))
  end

  def convert(value) when is_map(value),
    do: Any.new(type_url: "type.googleapis.com/string+json", value: Poison.encode!(value))

  def convert(value) when is_list(value),
    do:
      Any.new(
        type_url: "type.googleapis.com/list",
        value:
          Poison.Encoder.encode(value, %{})
          |> IO.iodata_to_binary()
      )

  @spec from(Google.Protobuf.Any.t()) :: any
  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/string",
      do: value

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/atom",
      do: String.to_existing_atom(value)

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/boolean",
      do: to_boolean(value)

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

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/string+json",
      do: Poison.decode!(value)

  def from(%Any{type_url: "type.googleapis.com/struct+json;" <> type, value: value} = _any),
    do: Poison.decode!(value, as: String.to_existing_atom(type))

  def from(%Any{type_url: type_url, value: value} = _any)
      when type_url == "type.googleapis.com/list" do
    Poison.decode!(value)
  end

  defp to_boolean("true"), do: true
  defp to_boolean("false"), do: false
end
