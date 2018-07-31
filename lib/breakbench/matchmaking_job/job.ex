defmodule Breakbench.MatchmakingJob.Job do
  @moduledoc false

  alias Breakbench.Matchmaking
  alias Breakbench.Matchmaking.{
    MatchmakingGameMode, MatchmakingRule, MatchmakingSpaceDistanceMatrix
  }
  alias Breakbench.MatchmakingJob.{
    DistanceMatrixBuilder, GameModeBuilder, RadiusBuilder
  }

  alias Ecto.Multi
  alias Breakbench.Repo


  def create(%Geo.Point{} = geom, %MatchmakingRule{} = rule, game_modes) do
    try do
      Multi.new()
        |> Multi.insert(:queue, Matchmaking.changeset_queue(%{
          geom: geom,
          rule_id: rule.id
        }))
        |> Multi.run(:build, fn %{queue: queue} ->
          # Initialise queue radius
          # Then, update queue radius with the init radius
          radius = RadiusBuilder.build(queue, :init)
          {:ok, queue} = Matchmaking.update_queue(queue, %{radius: radius})

          # Game modes
          game_mode_attrs = GameModeBuilder.build(queue, game_modes)
          Repo.insert_all(MatchmakingGameMode, game_mode_attrs)

          # Distance matrix
          matrix_attrs = DistanceMatrixBuilder.build(queue)
          Repo.insert_all(MatchmakingSpaceDistanceMatrix, matrix_attrs)

          {:ok, queue}
        end)
        |> Repo.transaction()
    catch
      MaxRadiusError -> :error
    end
  end
end
