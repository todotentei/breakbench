defmodule Breakbench.Auth.Secret do
  @moduledoc false
  alias Breakbench.Auth.KDF

  def generate(source, opts) do
    source
    |> get_key_base()
    |> validate_secret()
    |> KDF.run(opts)
  end


  ## Private

  defp get_key_base(%Plug.Conn{} = conn) do
    conn.secret_key_base
  end

  defp validate_secret(nil) do
    raise ArgumentError, "No secret_key_base is not set."
  end
  defp validate_secret(key) when byte_size(key) < 20 do
    raise ArgumentError, "The secret_key_base must be at least 20 bytes long."
  end
  defp validate_secret(key), do: key
end
