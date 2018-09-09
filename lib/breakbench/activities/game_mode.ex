defmodule Breakbench.Activities.GameMode do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_modes" do
    field :name, :string
    field :number_of_players, :integer
    field :duration, :integer


    belongs_to :sport, Breakbench.Activities.Sport,
      type: :string, foreign_key: :sport_name, references: :name


    timestamps()
  end

  @doc false
  def changeset(game_mode, attrs) do
    game_mode
    |> cast(attrs, [:name, :number_of_players, :duration, :sport_name])
    |> validate_required([:name, :number_of_players, :duration, :sport_name])
  end
end
