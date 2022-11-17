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

    test "call functions in decoded module" do
      raw_mod = ErlangEncoder.decode(ErlangEncoder.encode(Mod))
      random_property = :rand.uniform(1000)

      assert {:ok, %Mod{property: 1}} = raw_mod.some_function()

      assert {:ok, %Mod{property: ^random_property}} =
               raw_mod.some_function_with_args(random_property)
    end
  end
end
