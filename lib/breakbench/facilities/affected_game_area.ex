defmodule Breakbench.Facilities.AffectedGameArea do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "affected_game_areas" do
    belongs_to :game_area, Breakbench.Facilities.GameArea,
      type: :string, primary_key: true
    belongs_to :affected, Breakbench.Facilities.GameArea,
      type: :string, primary_key: true
  end

  @doc false
  def changeset(affected_game_area, attrs) do
    affected_game_area
    |> cast(attrs, [:game_area_id, :affected_id])
    |> validate_required([:game_area_id, :affected_id])
    |> check_constraint(:game_area_id, name: :ban_self_referencing)
    |> check_constraint(:game_area_id, name: :directionless)
  end
end
