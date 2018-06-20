defmodule Breakbench.WebhookTest do
  use ExUnit.Case, async: true

  alias Breakbench.Stripe.Webhook

  @payload ~S({"object": "event"})
  @secret "secret"

  @valid_schema "v1"
  @invalid_schema "v0"


  test "payload with a valid signature returns an event" do
    timestamp = System.system_time(:seconds)
    signature = generate_signature(timestamp)
    signature_header = create_signature_header(timestamp, signature)

    assert {:ok, _} = Webhook.construct_event(@payload, signature_header, @secret)
  end

  test "payload with an invalid signature returns error" do
    timestamp = System.system_time(:seconds)
    signature = generate_signature(timestamp, "random")
    signature_header = create_signature_header(timestamp, signature)

    assert {:error, _} = Webhook.construct_event(@payload, signature_header, @secret)
  end

  test "payload with an invalid secret returns error" do
    timestamp = System.system_time(:seconds)
    signature = generate_signature(timestamp, @payload, "random")
    signature_header = create_signature_header(timestamp, signature)

    assert {:error, _} = Webhook.construct_event(@payload, signature_header, @secret)
  end

  test "payload with an invalid schema returns error" do
    timestamp = System.system_time(:seconds)
    signature = generate_signature(timestamp)
    signature_header = create_signature_header(timestamp, @invalid_schema, signature)

    assert {:error, _} = Webhook.construct_event(@payload, signature_header, @secret)
  end


  ## Private

  defp create_signature_header(timestamp, schema \\ @valid_schema, signature) do
    "t=#{timestamp},#{schema}=#{signature}"
  end

  defp generate_signature(timestamp, payload \\ @payload, secret \\ @secret) do
    :sha256
      |> :crypto.hmac(secret, "#{timestamp}.#{payload}")
      |> Base.encode16(case: :lower)
  end
end
