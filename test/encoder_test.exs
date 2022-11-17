defmodule EncoderTest do
  use ExUnit.Case

  alias Steinadler.Encoder.ErlangEncoder
  alias SteinadlerTest.Support.Mod

  test "encode/decode erlang term to binary" do
    mod = %Mod{property: 1}
    encoded = ErlangEncoder.encode(mod)
    decoded = ErlangEncoder.decode(encoded)

    assert is_binary(encoded.binary)
    assert 1 == decoded.property
  end
end
