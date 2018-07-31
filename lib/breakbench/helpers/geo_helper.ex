defmodule Breakbench.GeoHelper do
  @moduledoc false


  def point_to_latlng(%Geo.Point{} = geom) do
    lat = elem(geom.coordinates, 1)
    lng = elem(geom.coordinates, 0)

    "#{lat}, #{lng}"
  end
end
