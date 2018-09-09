defmodule BreakbenchWeb.Auth.KDF do
  @moduledoc false
  alias Plug.Crypto.KeyGenerator
  alias BreakbenchWeb.Auth.Config

  import Keyword, only: [get: 2, get: 3]

  def run(secret_key_base, opts) do
    token_salt = get(opts, :token_salt, Config.token_salt())

    length = get(opts, :key_length)
    digest = get(opts, :key_digest)

    KeyGenerator.generate(secret_key_base, token_salt, [
      cache: Plug.Keys,
      iterations: get(opts, :key_iterations, 1000),
      length: validate_length(length),
      digest: validate_digest(digest)
    ])
  end


  ## Private

  defp validate_length(nil), do: 32
  defp validate_length(len) when len < 20 do
    raise ArgumentError, "The key_length must be at least 20 bytes long."
  end
  defp validate_length(len), do: len

  defp validate_digest(nil), do: :sha256
  defp validate_digest(digest) when digest in [:sha256, :sha512] do
    digest
  end
  defp validate_digest(digest) do
    raise ArgumentError, "The key_digest does not support #{digest}."
  end
end
