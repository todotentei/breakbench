defmodule Breakbench.Geocode.ColloquialAreaComponent do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode. {
    AdministrativeAreaLevel1Component, AdministrativeAreaLevel2Component,
    PostalCodeComponent, LocalityComponent
  }
  alias Breakbench.AddressComponents.{
    Country, ColloquialArea, AdministrativeAreaLevel1ColloquialAreas,
    ColloquialAreaAdministrativeAreaLevel2s, ColloquialAreaPostalCodes,
    ColloquialAreaLocalities
  }


  address_component :colloquial_area, belongs_to: :country

  belongs_to AdministrativeAreaLevel1Component,
    join_through: AdministrativeAreaLevel1ColloquialAreas

  has_many AdministrativeAreaLevel2Component,
    join_through: ColloquialAreaAdministrativeAreaLevel2s
  has_many PostalCodeComponent,
    join_through: ColloquialAreaPostalCodes
  has_many LocalityComponent,
    join_through: ColloquialAreaLocalities

  @doc """
  Resolve colloquial_area
  """
  def resolve(%Country{} = country, %__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %ColloquialArea{} = colloquial_area <- country
           |> Ecto.assoc(:colloquial_areas)
           |> where(^Enum.to_list(attrs))
           |> Repo.one
    do
      {:old, colloquial_area}
    else _ ->
      {:ok, colloquial_area} = country
        |> Ecto.build_assoc(:colloquial_areas)
        |> Ecto.Changeset.change(attrs)
        |> Repo.insert
      {:new, colloquial_area}
    end
  end
end
