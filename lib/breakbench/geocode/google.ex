defmodule Breakbench.Geocode.Google do
  use GenServer

  @doc false
  def start_link, do: GenServer.start_link(__MODULE__, [])

  ## API

  @doc """
  Cache new address components
  """
  def resolve(geocode) do
    GenServer.cast(__MODULE__, {:resolve, geocode})
  end


  alias Breakbench.Geocode
  import Keyword, only: [fetch!: 2, get_lazy: 3]

  use Breakbench.GeocodeBehaviour

  perform Geocode.CountryComponent, :mandatory
  perform Geocode.AdministrativeAreaLevel1Component
  perform Geocode.ColloquialAreaComponent
  perform Geocode.AdministrativeAreaLevel2Component
  perform Geocode.PostalCodeComponent
  perform Geocode.LocalityComponent
  perform Geocode.Geometry


  ## Callbacks

  @doc false
  def init(_), do: {:ok, []}

  @doc false
  def terminate(_reason, _state), do: :ok

  @doc false
  def handle_cast({:resolve, geocode}, state) do
    Breakbench.Geocode.GoogleDepot.resolve(geocode)
    {:noreply, state}
  end

  @doc """
  Constructs HTTPoison headers
  """
  def headers(%{language: language}) do
    [{"Accept-Language", language}]
  end

  @doc """
  Constructs url with query
  """
  def url(endpoint, format, data) do
    Path.join([endpoint, "geocode", format])
      <> "?"
      <> URI.encode_query(data)
  end

  @doc """
  Makes request
  """
  def request(address) do
    if config = Application.get_env(:breakbench, Google) do
      destructure([api_key, endpoint, format, language], [
        fetch!(config, :geocode_api_key),
        get_lazy(config, :endpoint, fn ->
          "https://maps.googleapis.com/maps/api/"
        end),
        get_lazy(config, :format, fn -> "json" end),
        get_lazy(config, :language, fn -> "en" end)
      ])
      headers = headers(%{language: language})
      options = get_lazy(config, :httpoison, fn -> [] end)
      # Issues a GET request to the given url
      url(endpoint, format, %{address: address, key: api_key})
        |> HTTPoison.get(headers, options)
        |> parse_http_response
        |> parse_geocode
    else
      {:error, "no google configuration"}
    end
  end

  ## Private

  defp parse_http_response({:ok, %{status_code: 200, body: body}}) do
    response = body
      |> Poison.decode!()
      |> AtomicMap.convert(safe: false)
    {:ok, response}
  end

  defp parse_http_response({:error, error}) do
    {:error, error}
  end

  defp parse_geocode({:ok, %{results: results, status: "OK"}}) do
    Enum.map(results, fn %{address_components: ac, geometry: gm} ->
      struct(__MODULE__, Enum.reduce(__components__(), [], fn component, acc ->
        cond do
          match?(Geocode.Geometry, component) ->
            geometry = Geocode.Geometry.new(gm.location.lat, gm.location.lng)
            [{component.field, geometry} | acc]
          true ->
            case Enum.find(ac, & to_string(component.field) in &1.types) do
              %{short_name: sn, long_name: ln} ->
                [{component.field, component.new(sn, ln)} | acc]
              _ ->
                acc
            end
        end
      end))
    end)
  end
end
