defmodule Breakbench.Stripe.HTTPClient do
  @moduledoc false

  alias Breakbench.Stripe.Query
  alias Breakbench.StripeConnect.Account

  @doc """
  Constructs HTTPoison headers
  """
  def headers(_account \\ nil, _attrs)
  def headers(%Account{id: account}, attrs) do
    [{"Stripe-Account", account} | headers(attrs)]
  end

  def headers(_, %{secret: secret, version: version}) do
    [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Stripe-Version", version}, {"Authorization", "Bearer #{secret}"}
    ]
  end

  @doc """
  Constructs url with query
  """
  def url(endpoint, schema, path, data) do
    Path.join([endpoint, schema, path])
      <> "?"
      <> Query.encode(data)
  end

  def request(method, path, account \\ nil, data)
      when method in [:get, :post, :delete] do
    import Keyword, only: [fetch!: 2, get: 3]
    if config = Application.get_env(:breakbench, Stripe) do
      unless get(config, :test_mode, false) do
        # Secret key
        secret = fetch!(config, :secret)
        # Default configuration
        destructure([endpoint, schema, version, options], [
          get(config, :endpoint, "https://api.stripe.com/"),
          get(config, :schema, "v1"),
          get(config, :version, "2017-06-05"),
          get(config, :httpoison, [])
        ])

        headers = headers(account, %{secret: secret, version: version})
        url = url(endpoint, schema, path, data)

        method
          |> HTTPoison.request(url, "", headers, options)
          |> parse_http_response
      else
        mock_server = fetch!(config, :mock_server)
        mock_server.request(method, path, data)
      end
    else
      {:error, "no stripe configuration"}
    end
  end


  ## Private

  defp parse_http_response({:ok, %{status_code: status_code, body: body}})
       when status_code in 200..299 do
    {:ok, decodep(body)}
  end

  defp parse_http_response({:ok, %{status_code: status_code, body: body}})
       when status_code in 400..499 do
    response = decodep(body)
    {:error, response.error}
  end

  defp parse_http_response({:error, error}) do
    {:error, error}
  end

  defp decodep(body) do
    body
      |> Poison.decode!()
      |> AtomicMap.convert(safe: false)
  end
end