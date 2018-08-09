defmodule Breakbench.Facilities.FieldGameMode do
  use Ecto.Schema
  import Ecto.Changeset


  schema "field_game_modes" do
    belongs_to :field, Breakbench.Facilities.Field,
      type: :string
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id
  end

  @doc false
  def changeset(field_game_mode, attrs) do
    field_game_mode
      |> cast(attrs, [:field_id, :game_mode_id])
      |> validate_required([:field_id, :game_mode_id])
  end
end
