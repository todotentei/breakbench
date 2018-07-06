defmodule Breakbench.Places.Ground do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :string, []}
  schema "grounds" do
    field :description, :string
    field :default_price, :integer


    belongs_to :space, Breakbench.Places.Space,
      type: :string


    has_many :grounds_sports, Breakbench.Places.GroundSport
    has_many :closing_hours, Breakbench.Places.GroundClosingHour


    timestamps()
  end

  @doc false
  def changeset(ground, attrs) do
    ground
      |> cast(attrs, [:id, :description, :default_price, :space_id])
      |> validate_required([:id, :space_id])
  end
end
