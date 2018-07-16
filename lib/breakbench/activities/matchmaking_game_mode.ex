defmodule Breakbench.Activities.MatchmakingGameMode do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "matchmaking_game_modes" do
    belongs_to :matchmaking_queue, Breakbench.Activities.MatchmakingQueue,
      type: :binary_id
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id
  end

  @doc false
  def changeset(game_mode, attrs) do
    game_mode
      |> cast(attrs, [:matchmaking_queue_id, :game_mode_id])
      |> validate_required([:matchmaking_queue_id, :game_mode_id])
  end
end
