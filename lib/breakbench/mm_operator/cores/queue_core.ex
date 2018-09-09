defmodule Breakbench.MMOperator.Cores.QueueCore do
  @moduledoc false

  alias Breakbench.Repo

  alias Breakbench.Matchmaking
  alias Breakbench.SpaceUtil

  alias Breakbench.Accounts.User
  alias Breakbench.Matchmaking.MatchmakingRule, as: Rule
  alias Breakbench.MMOperator.Builders.{
    DistanceMatrixBuilder,
    GameModeBuilder,
    QueueBuilder
  }

  def run(%User{} = user, %Rule{} = rule, %Geo.Point{} = geom, game_modes) do
    Repo.transaction fn ->
      with spaces when length(spaces) > 0 <- SpaceUtil.list(geom, rule.radius, game_modes) do
        case new_mmq(user, rule, geom) do
          {:ok, queue} ->
            mgm_entries = GameModeBuilder.build(queue, game_modes)
            Matchmaking.insert_all_game_modes(mgm_entries)

            msd_entries = DistanceMatrixBuilder.build(queue, spaces)
            Matchmaking.insert_all_space_distance_matrix(msd_entries)

            queue
          {:error, _} ->
            Repo.rollback(:new_queue_error)
        end
      else
        _ ->
          Repo.rollback(:no_nearby_spaces)
      end
    end
  end


  ## Private

  defp new_mmq(user, rule, geom) do
    user
    |> QueueBuilder.build(rule, geom)
    |> Matchmaking.create_queue()
  end
end
