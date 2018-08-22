defmodule Breakbench.MMOperator.DistanceMatrixBuilder do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.GeoHelper

  alias Breakbench.Matchmaking.MatchmakingQueue, as: Queue
  alias Breakbench.Facilities.Space


  def build(%Queue{} = queue, spaces) do
    # Associated rule
    rule = assoc_rule(queue)

    # Use queue as origin and spaces as destinations
    origin = GeoHelper.to_string(queue.geom)
    destinations = Enum.map(spaces, & extract_location/1)
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

  defp extract_location(%Space{geom: geom}) do
    GeoHelper.to_string(geom)
  end

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
