defmodule Breakbench.GoogleAPIs do
  @moduledoc false
  import Breakbench.GoogleAPIs.Base, only: [request: 2]


  @doc """
  The Directions API is a service that calculates directions between locations.
  You can search for directions for several modes of transportation, including
  transit, driving, walking, or cycling.
  """
  def directions(data) do
    request("maps/api/directions", data)
  end

  @doc """
  The Distance Matrix API is a service that provides travel distance and time
  for a matrix of origins and destinations, based on the recommended route
  between start and end points.
  """
  def distance_matrix(data) do
    request("maps/api/distancematrix", data)
  end

  @doc """
  The Elevation API provides elevation data for all locations on the surface
  of the earth, including depth locations on the ocean floor (which return negative
  values)
  """
  def elevation(data) do
    request("maps/api/elevation", data)
  end

  @doc """
  The Geocoding API is a service that provides geocoding and reverse geocoding
  of address.
  """
  def geocode(data) do
    request("maps/api/geocode", data)
  end

  @doc """
  The Time Zone API provides time offset data for locations on the surface of the
  earth. You request the time zone information for a specific latitude/longitude
  pair and data. The API returns the name of that time zone, the time offset from
  UTC, and the daylight savings offset.
  """
  def timezone(data) do
    request("maps/api/timezone", data)
  end
end
