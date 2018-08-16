defmodule Breakbench.MMOperator.QueueProcess do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.GeoHelper

  alias Breakbench.{
    Accounts, Activities, Matchmaking
  }

  alias Breakbench.Matchmaking.{
    MatchmakingGameMode, MatchmakingSpaceDistanceMatrix
  }
  alias Breakbench.MMOperator.QueueValidator
  alias Breakbench.MMOperator.{
    DistanceMatrixBuilder, GameModeBuilder, QueueBuilder
  }

  def run(attrs) do
    Repo.transaction fn ->
      {:ok, attrs} = QueueValidator.validate(attrs)

      user = Accounts.get_user!(attrs.user_id)
      rule = Matchmaking.get_rule!(attrs.rule_id)
      geom = GeoHelper.latlng_to_point(attrs.location)

      case user
      |> QueueBuilder.build(rule, geom)
      |> Matchmaking.create_queue() do
        {:ok, queue} ->
          game_modes = attrs.game_modes
          |> Enum.map(& Activities.get_game_mode!(&1))

          gm_attrs = GameModeBuilder.build(queue, game_modes)
          Repo.insert_all(MatchmakingGameMode, gm_attrs)

          dm_attrs = DistanceMatrixBuilder.build(queue)
          Repo.insert_all(MatchmakingSpaceDistanceMatrix, dm_attrs)

          queue
        {:error, _} -> Repo.rollback(:new_queue_error)
      end
    end
  end
end
