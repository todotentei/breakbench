defmodule Breakbench.Auth.Message do
  @enforce_keys [:data, :exp]
  defstruct [:data, :exp]
end

defmodule Breakbench.Auth.Token do
  @moduledoc false

  alias Breakbench.Auth.Message
  alias Breakbench.Auth.Secret
  alias Plug.Crypto.MessageVerifier

  def sign(source, data, opts \\ []) do
    age = Keyword.get(opts, :max_age, 14400)
    msg = [
      data: data,
      exp: System.system_time(:second) + age
    ]

    secret = Secret.generate(source, opts)
    struct(Message, msg)
    |> Jason.encode!()
    |> MessageVerifier.sign(secret)
  end

  def verify(source, token, opts \\ [])
  def verify(source, token, opts) when is_binary(token) do
    secret = Secret.generate(source, opts)

    case MessageVerifier.verify(token, secret) do
      {:ok, message} ->
        message
        |> Jason.decode!()
        |> handle_verify()
      _ ->
        {:error, "invalid token"}
    end
  end


  ## Private

  defp handle_verify(%Message{} = message) do
    unless message.exp < System.system_time(:second) do
      {:ok, message.data}
    else
      {:error, "expired token"}
    end
  end
  defp handle_verify(_), do: {:error, "invalid token"}
end
