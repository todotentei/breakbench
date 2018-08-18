defmodule Breakbench.Facilities.GameAreaMode do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_area_modes" do
    belongs_to :game_area, Breakbench.Facilities.GameArea,
      type: :binary_id
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id
  end

  @doc false
  def changeset(game_area_mode, attrs) do
    game_area_mode
    |> cast(attrs, [:game_area_id, :game_mode_id])
    |> validate_required([:game_area_id, :game_mode_id])
  end
end
