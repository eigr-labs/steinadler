defmodule Steinadler.Encoder.ErlangEncoder do
  @behaviour Steinadler.Encoder.Encoder

  alias Eigr.Steinadler.Protocol.V1.Term

  def encode(term), do: Term.new(binary: :erlang.term_to_binary(term))

  def decode(%Term{binary: binary} = _type) when is_binary(binary),
    do: :erlang.binary_to_term(binary)
end
