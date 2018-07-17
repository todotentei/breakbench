defmodule Breakbench.GoogleAPIs.Base do
  @moduledoc false

  alias Breakbench.GoogleAPIs.Query
  import Keyword, only: [fetch!: 2, get: 3]


  @doc """
  Constructs HTTPoison headers
  """
  def headers(%{language: language}) do
    [{"Accept-Language", language}]
  end

  @doc """
  Constructs url with query
  """
  def url(endpoint, service, format, data) do
    Path.join([endpoint, service, format])
      <> "?"
      <> Query.encode(data)
  end

  @doc """
  Makes request via specific service
  """
  def request(service, data) do
    if config = Application.get_env(:breakbench, Breakbench.GoogleAPIs) do
      # Api key must exist
      api_key = fetch!(config, :api_key)

      # Returns default if no configuration was found for the specific keyword
      endpoint = get(config, :endpoint, "https://maps.googleapis.com/maps/api/")
      format = get(config, :format, "json")
      language = get(config, :language, "en")

      # Builds header and other options
      headers = headers(%{language: language})
      options = get(config, :httpoison, [])
      # Issues a GET request to the given url
      query = Map.merge(data, %{key: api_key})
      url(endpoint, service, format, query)
        |> HTTPoison.get(headers, options)
        |> parse_http_response
    else
      {:error, "no google configuration"}
    end
  end

  ## Private

  defp parse_http_response({:ok, %{status_code: 200, body: body}}) do
    response = atomic_decode(body)
    {:ok, response}
  end
  defp parse_http_response({:ok, %{status_code: 400, body: body}}) do
    response = atomic_decode(body)
    {:error, response}
  end
  defp parse_http_response({:error, error}) do
    {:error, error}
  end
  defp parse_http_response(_), do: :error

  defp atomic_decode(data) do
    data
      |> Poison.decode!()
      |> AtomicMap.convert(safe: false)
  end
end
