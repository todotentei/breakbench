defmodule Breakbench.AddressComponents.Country do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :short_name}
  @primary_key {:short_name, :string, []}
  schema "countries" do
    field :long_name, :string

    has_many :administrative_area_level_1s, Breakbench.AddressComponents.AdministrativeAreaLevel1
    has_many :colloquial_areas, Breakbench.AddressComponents.ColloquialArea
    has_many :administrative_area_level_2s, Breakbench.AddressComponents.AdministrativeAreaLevel2
    has_many :postal_codes, Breakbench.AddressComponents.PostalCode
    has_many :localities, Breakbench.AddressComponents.Locality
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:short_name, :long_name])
    |> validate_required([:short_name, :long_name])
    |> unique_constraint(:long_name)
  end
end
