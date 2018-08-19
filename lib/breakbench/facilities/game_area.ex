defmodule Breakbench.Facilities.GameArea do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "game_areas" do
    field :name, :string
    field :default_price, :integer

    belongs_to :area, Breakbench.Facilities.Area,
      type: :binary_id

    has_many :closing_hours, Breakbench.Facilities.GameAreaClosingHour
    has_many :dynamic_pricings, Breakbench.Facilities.GameAreaDynamicPricing

    timestamps()
  end

  @doc false
  def changeset(game_area, attrs) do
    game_area
    |> cast(attrs, [:id, :name, :area_id, :default_price])
    |> validate_required([:id, :area_id, :default_price])
  end
end
