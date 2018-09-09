defmodule Breakbench.StripeAPIs.Base do
  @moduledoc false

  alias Breakbench.StripeAPIs.Query


  @doc """
  Constructs HTTPoison headers
  """
  def headers(%{secret: secret, version: version}) do
    [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Stripe-Version", version}, {"Authorization", "Bearer #{secret}"}
    ]
  end

  def headers(account, attrs) do
    if account do
      [{"Stripe-Account", account} | headers(attrs)]
    else
      headers(attrs)
    end
  end

  @doc """
  Constructs url with query
  """
  def url(endpoint, schema, path, data) do
    main_path = Path.join([endpoint, schema, path])
    encoded_data = Query.encode(data)

    "#{main_path}?#{encoded_data}"
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
