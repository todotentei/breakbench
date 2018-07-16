defmodule Breakbench.Places.GroundGameMode do
  use Ecto.Schema
  import Ecto.Changeset


  schema "grounds_game_modes" do
    belongs_to :ground, Breakbench.Places.Ground,
      type: :string
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id


    timestamps()
  end

  @doc false
  def changeset(ground_game_mode, attrs) do
    ground_game_mode
      |> cast(attrs, [:ground_id, :game_mode_id])
      |> validate_required([:ground_id, :game_mode_id])
  end
end
