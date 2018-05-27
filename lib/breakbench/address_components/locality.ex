defmodule Breakbench.AddressComponents.Locality do
  use Ecto.Schema
  import Ecto.Changeset


  schema "localities" do
    field :long_name, :string
    field :short_name, :string

    belongs_to :country, Breakbench.AddressComponents.Country,
      foreign_key: :country_short_name, references: :short_name, type: :string

    has_one :administrative_area_level_1_conjunction,
      Breakbench.AddressComponents.AdministrativeAreaLevel1Localities
    has_one :colloquial_area_conjunction,
      Breakbench.AddressComponents.ColloquialAreaLocalities
    has_one :administrative_area_level_2_conjunction,
      Breakbench.AddressComponents.AdministrativeAreaLevel2Localities
    has_one :postal_code_conjunction,
      Breakbench.AddressComponents.PostalCodeLocalities

    has_one :administrative_area_level_1, through:
      [:administrative_area_level_1_conjunction, :administrative_area_level_1]
    has_one :colloquial_area, through:
      [:colloquial_area_conjunction, :colloquial_area]
    has_one :administrative_area_level_2, through:
      [:administrative_area_level_2_conjunction, :administrative_area_level_2]
    has_one :postal_code, through:
      [:postal_code_conjunction, :postal_code]

    timestamps()
  end

  @doc false
  def changeset(locality, attrs) do
    locality
    |> cast(attrs, [:country_short_name, :short_name, :long_name])
    |> validate_required([:country_short_name, :short_name, :long_name])
    |> unique_constraint(:country_short_name, name: :localities_country_short_name_long_name_index)
  end
end
