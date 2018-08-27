defmodule Breakbench.Activities.Sport do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :name}
  @primary_key {:name, :string, []}
  schema "sports" do
    field :type, :string

    has_many :game_modes, Breakbench.Activities.GameMode
  end

  @doc false
  def changeset(sport, attrs) do
    sport
    |> cast(attrs, [:name, :type])
    |> validate_required([:name])
  end
end
