defmodule Breakbench.Places.GroundSport do
  use Ecto.Schema
  import Ecto.Changeset


  schema "grounds_sports" do
    belongs_to :ground, Breakbench.Places.Ground,
      type: :string
    belongs_to :sport, Breakbench.Activities.Sport,
      type: :string, foreign_key: :sport_name, references: :name


    timestamps()
  end

  @doc false
  def changeset(ground_sport, attrs) do
    ground_sport
      |> cast(attrs, [:ground_id, :sport_name])
      |> validate_required([:ground_id, :sport_name])
  end
end
