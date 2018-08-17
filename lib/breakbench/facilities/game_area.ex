defmodule Breakbench.Facilities.GameArea do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :string, []}
  schema "game_areas" do
    field :name, :string

    belongs_to :area, Breakbench.Facilities.Area,
      type: :binary_id

    has_many :closing_hours, Breakbench.Facilities.GameAreaClosingHour

    timestamps()
  end

  @doc false
  def changeset(game_area, attrs) do
    game_area
    |> cast(attrs, [:id, :name, :area_id])
    |> validate_required([:id, :area_id])
  end
end
