defmodule Breakbench.Sport do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :name}
  @primary_key {:name, :string, []}
  schema "sports" do
    field :type, :string
  end

  @doc false
  def changeset(sport, attrs) do
    sport
    |> cast(attrs, [:name, :type])
    |> validate_required([:name])
  end
end
