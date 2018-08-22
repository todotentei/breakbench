defmodule Breakbench.MMOperator.QueueProcess do
  @moduledoc false

  alias Breakbench.Repo

  alias Breakbench.Matchmaking
  alias Breakbench.SpaceUtil

  alias Breakbench.Accounts.User
  alias Breakbench.Matchmaking.MatchmakingRule, as: Rule
  alias Breakbench.Matchmaking.{
    MatchmakingGameMode, MatchmakingSpaceDistanceMatrix
  }
  alias Breakbench.MMOperator.{
    DistanceMatrixBuilder, GameModeBuilder, QueueBuilder
  }

  def run(%User{} = user, %Rule{} = rule, %Geo.Point{} = geom, game_modes) do
    Repo.transaction fn ->
      with spaces when length(spaces) > 0 <- geom
        |> SpaceUtil.list(rule.radius, game_modes)
      do
        case user
          |> QueueBuilder.build(rule, geom)
          |> Matchmaking.create_queue()
        do
          {:ok, queue} ->
            MatchmakingGameMode
            |> Repo.insert_all(GameModeBuilder.build(queue, game_modes))

            MatchmakingSpaceDistanceMatrix
            |> Repo.insert_all(DistanceMatrixBuilder.build(queue, spaces))

            queue
          {:error, _} -> Repo.rollback(:new_queue_error)
        end
      else
        _ -> Repo.rollback(:no_nearby_spaces)
      end
    end
  end
end
