defmodule Steinadler.Dist.Protocol.Token do
  @moduledoc false

  @iss "Steinadler"
  @algorithm "HS256"
  @secret Atom.to_string(Node.get_cookie())

  def create(claims) do
    token_config =
      %{}
      |> Map.put("iss", %Joken.Claim{
        generate: fn -> @iss end,
        validate: fn val, _claims, _context -> val == @iss end
      })

    {:ok, claims} = Joken.generate_claims(token_config, claims)
    {:ok, jwt, _claims} = Joken.encode_and_sign(claims, Joken.Signer.create(@algorithm, @secret))
    jwt
  end

  def validate(token) do
    token_config =
      %{}
      |> Map.put("iss", %Joken.Claim{
        generate: fn -> @iss end,
        validate: fn val, _claims, _context -> val == @iss end
      })

    Joken.verify_and_validate(token_config, token, Joken.Signer.create(@algorithm, @secret))
  end
end
