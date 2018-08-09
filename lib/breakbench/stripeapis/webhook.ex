defmodule Breakbench.StripeAPIs.Webhook do
  @moduledoc """
  Creates an event from webhook's payload if signature is valid.

  Use `construct_event/3` to verify the authenticity of a webhook request and
  convert its payload into a map representing the event.
  """

  import Bitwise, only: [bor: 2, ^^^: 2]

  config = Application.get_env(:breakbench, Stripe)
  tolerance = config
    |> Keyword.get(:webhook, [])
    |> Keyword.get(:tolerance, 300000)

  @schema Keyword.get(config, :schema, "v1")
  @tolerance round(tolerance / 1000) # seconds


  def construct_event(payload, header, secret, tolerance \\ @tolerance) do
    # Verify header
    case get_timestamp_and_signatures(header, @schema) do
      {nil, _} ->
        {:error, "Unable to extract timestamp and signatures from header"}
      {_, []} ->
        {:error, "No signatures found with expected scheme #{@schema}"}
      {timestamp, signatures} ->
        with {:ok, timestamp} <- validate_timestamp(timestamp, tolerance),
             {:ok, _signatures} <- validate_signatures(signatures, timestamp, payload, secret)
        do
          event = payload
            |> Poison.decode!
            |> AtomicMap.convert(safe: false)
          {:ok, event}
        else
          error -> error
        end
    end
  end


  ## Private

  def get_timestamp_and_signatures(signature_header, schema) do
    signature_header
      |> String.split(",")
      |> Enum.map(&String.split(&1, "="))
      |> Enum.reduce({nil, []}, fn
        ["t", timestamp], {nil, signatures} ->
          {to_integer(timestamp), signatures}
        [^schema, signature], {timestamp, signatures} ->
          {timestamp, [signature | signatures]}
        _, accumulator ->
          accumulator
      end)
  end

  defp validate_timestamp(timestamp, tolerance) do
    now = System.system_time(:seconds)
    # Check time is within range
    case timestamp >= (now - tolerance) do
       true -> {:ok, timestamp}
      false -> {:error, "Timestamp outside the tolerance zone (#{now})"}
    end
  end

  defp validate_signatures(signatures, timestamp, payload, secret) do
    expected_signature = compute_signature("#{timestamp}.#{payload}", secret)
    # Check if signatures contain any expected signature
    case Enum.any?(signatures, &secure_equal?(&1, expected_signature)) do
       true -> {:ok, signatures}
      false -> {:error, "No signatures found matching the expected signature for payload"}
    end
  end

  defp compute_signature(payload, secret) do
    :sha256
      |> :crypto.hmac(secret, payload)
      |> Base.encode16(case: :lower)
  end

  defp secure_equal?(input, expected) when byte_size(input) == byte_size(expected) do
    input = String.to_charlist(input)
    expected = String.to_charlist(expected)
    secure_compare(input, expected)
  end

  defp secure_compare(accumulator \\ 0, input, expected)
  defp secure_compare(accumulator, [], []) do
    accumulator == 0
  end

  defp secure_compare(accumulator, [input_codepoint | input],
       [expected_codepoint | expected]) do
    accumulator
      |> bor(input_codepoint ^^^ expected_codepoint)
      |> secure_compare(input, expected)
  end

  defp to_integer(timestamp) do
    case Integer.parse(timestamp) do
      {timestamp, _} -> timestamp
      :error -> nil
    end
  end
end
