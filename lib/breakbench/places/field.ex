defmodule Breakbench.Places.Field do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :string, []}
  schema "fields" do
    field :name, :string


    belongs_to :ground, Breakbench.Places.Ground,
      type: :string


    has_many :closing_hours, Breakbench.Places.FieldClosingHour
    has_many :dynamic_pricings, Breakbench.Places.FieldDynamicPricing


    timestamps()
  end

  @doc false
  def changeset(field, attrs) do
    field
      |> cast(attrs, [:id, :name, :ground_id])
      |> validate_required([:id, :ground_id])
  end
end
