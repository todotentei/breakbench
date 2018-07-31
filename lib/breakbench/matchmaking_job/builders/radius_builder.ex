defmodule Breakbench.MatchmakingJob.RadiusBuilder do
  @moduledoc """
  Radius Builder
  """

  alias Breakbench.{
    Repo, MathHelper
  }

  alias Breakbench.Places.Space
  alias Breakbench.Matchmaking.MatchmakingQueue

  import Ecto.Query
  import Geo.PostGIS, only: [st_distancesphere: 2]


  @doc """
  Build initialise and next radius
  """
  def build(%MatchmakingQueue{} = queue, :init) do
    # Queue associated rule
    rule = assoc_rule(queue)
    # Check the nearest space distance
    radius = min(queue.geom)

    # Throw error if radius exceed max_radius
    if radius > rule.max_radius do
      raise Breakbench.MaxRadiusError
    end

    # Ceiling radius to the nearest multiple of expansion rate
    radius
      |> MathHelper.ceil_to_the_nearest_multiple(rule.radius_expansion_rate)
      |> trim_limit(rule.max_radius)
      |> round()
  end

  # Next radius returns current queue radius added with radius expension rate
  def build(%MatchmakingQueue{} = queue, :next) do
    # Load queue rule
    rule = assoc_rule(queue)

    # Increases radius with the expansion rate
    queue.radius
      |> Kernel.+(rule.radius_expansion_rate)
      |> round()
  end


  ## Private

  # Minimum radius is the distance of the nearest space
  defp min(%Geo.Point{} = geom) do
    from(Space)
      |> select([spc], st_distancesphere(spc.geom, ^geom))
      |> order_by([spc], st_distancesphere(spc.geom, ^geom))
      |> limit(1)
      |> Repo.one
  end

  defp trim_limit(number, limit) do
    if number > limit do
      limit
    else
      number
    end
  end

  defp assoc_rule(queue) do
    queue
      |> Ecto.assoc(:rule)
      |> Repo.one
  end
end
