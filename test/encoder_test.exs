defmodule EncoderTest do
  use ExUnit.Case

  alias Steinadler.Encoder.ErlangEncoder
  alias SteinadlerTest.Support.Mod

  describe "encode/decode" do
    test "erlang term to binary and vice-versa" do
      mod = %Mod{property: 1}
      encoded = ErlangEncoder.encode(mod)
      decoded = ErlangEncoder.decode(encoded)

      assert is_binary(encoded.binary)
      assert 1 == decoded.property
    end

    test "decode and call function" do
      func = fn a, b -> a + b end
      encoded_func = ErlangEncoder.encode(func)
      decoded_func = ErlangEncoder.decode(encoded_func)

      assert 5 == decoded_func.(2, 3)
    end
  end
end
