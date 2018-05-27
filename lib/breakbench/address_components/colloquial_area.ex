defmodule Breakbench.AddressComponents.ColloquialArea do
  use Ecto.Schema
  import Ecto.Changeset


  schema "colloquial_areas" do
    field :long_name, :string
    field :short_name, :string

    belongs_to :country, Breakbench.AddressComponents.Country,
      foreign_key: :country_short_name, references: :short_name, type: :string

    timestamps()
  end

  @doc false
  def changeset(colloquial_area, attrs) do
    colloquial_area
    |> cast(attrs, [:country_short_name, :short_name, :long_name])
    |> validate_required([:country_short_name, :short_name, :long_name])
    |> unique_constraint(:country_short_name, name: :colloquial_areas_country_short_name_long_name_index)
  end
end
