defmodule Breakbench.GeoHelper do
  @moduledoc false

  def latlng_to_point(geom, srid \\ 4326)
  def latlng_to_point(%{"lat" => lat, "lng" => lng}, srid) do
    geom = %{lat: lat, lng: lng}
    latlng_to_point(geom, srid)
  end
  def latlng_to_point(%{lat: lat, lng: lng}, srid) do
    %Geo.Point{
      coordinates: {lng, lat},
      srid: srid
    }
  end

  def point_to_latlng(%Geo.Point{} = geom) do
    %{
      lat: elem(geom.coordinates, 1),
      lng: elem(geom.coordinates, 0)
    }
  end

  def to_string(%Geo.Point{} = geom) do
    geom
    |> point_to_latlng()
    |> __MODULE__.to_string()
  end
  def to_string(%{lat: lat, lng: lng}) do
    "#{lat}, #{lng}"
  end
end
