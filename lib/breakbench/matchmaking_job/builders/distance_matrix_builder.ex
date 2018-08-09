defmodule Breakbench.MatchmakingJob.DistanceMatrixBuilder do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.Facilities
  alias Breakbench.GeoHelper

  alias Breakbench.Matchmaking.MatchmakingQueue


  def build(%MatchmakingQueue{} = queue) do
    # Associated rule
    rule = assoc_rule(queue)

    # Nearby spaces
    spaces = Facilities.list_spaces(queue.geom, queue.radius)

    # Use geom as origin and spaces as destinations
    origin = GeoHelper.point_to_latlng(queue.geom)
    destinations = Enum.map(spaces, &GeoHelper.point_to_latlng(&1.geom))
    matrix_params = %{
      mode: rule.travel_mode_type,
      origins: origin,
      destinations: destinations
    }
    {:ok, matrix} = Breakbench.GoogleAPIs.distance_matrix(matrix_params)

    # List of elements related to the target origin
    elements = Map.get(hd(matrix.rows), :elements)

    # Zips corresponding spaces and elements
    # Filter out element that has no results
    # Then, map it into space distance matrix attrs
    [spaces, elements]
      |> Enum.zip()
      |> Enum.filter(fn {_, %{status: status}} -> status == "OK" end)
      |> Enum.map(&space_distance_matrix_attrs(queue, &1))
  end


  ## Private

  defp space_distance_matrix_attrs(queue, {space, elements}) do
    %{
      distance: elements.distance.value,
      duration: elements.duration.value,
      space_id: space.id,
      matchmaking_queue_id: queue.id
    }
  end

  defp assoc_rule(queue) do
    queue
      |> Ecto.assoc(:rule)
      |> Repo.one
  end
end
