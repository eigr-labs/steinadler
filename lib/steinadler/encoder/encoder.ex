defmodule Steinadler.Encoder.Encoder do
  alias Eigr.Steinadler.Protocol.V1.Term

  @type type :: Term.t()

  @callback encode(term()) :: type()
  @callback decode(type()) :: term()
end
