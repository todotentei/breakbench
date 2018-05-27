defmodule Breakbench.Geocode.Geometry do
  @moduledoc false

  @enforce_keys [:latitude, :longitude]
  defstruct [
    latitude: nil, longitude: nil
  ]

  def new(latitude, longitude)
      when is_number(latitude) and is_number(longitude) do
    struct(__MODULE__, [
      {:latitude, latitude}, {:longitude, longitude}
    ])
  end

  def field, do: :geometry
end
