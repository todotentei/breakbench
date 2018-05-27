defmodule Breakbench.Geocode.AdministrativeAreaLevel2Component do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode.{
    AdministrativeAreaLevel1Component, ColloquialAreaComponent,
    PostalCodeComponent, LocalityComponent
  }
  alias Breakbench.AddressComponents.{
    Country, AdministrativeAreaLevel2, AdministrativeAreaLevel1AdministrativeAreaLevel2s,
    ColloquialAreaAdministrativeAreaLevel2s, AdministrativeAreaLevel2PostalCodes,
    AdministrativeAreaLevel2Localities
  }


  address_component :administrative_area_level_2,
    belongs_to: :country

  belongs_to AdministrativeAreaLevel1Component,
    join_through: AdministrativeAreaLevel1AdministrativeAreaLevel2s
  belongs_to ColloquialAreaComponent,
    join_through: ColloquialAreaAdministrativeAreaLevel2s

  has_many PostalCodeComponent,
    join_through: AdministrativeAreaLevel2PostalCodes
  has_many LocalityComponent,
    join_through: AdministrativeAreaLevel2Localities

  @doc """
  Resolve administrative_area_level_2
  """
  def resolve(%Country{} = country, %__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %AdministrativeAreaLevel2{} = area_level2 <- country
           |> Ecto.assoc(:administrative_area_level_2s)
           |> where(^Enum.to_list(attrs))
           |> Repo.one
    do
      {:old, area_level2}
    else _ ->
      {:ok, area_level2} = country
        |> Ecto.build_assoc(:administrative_area_level_2s)
        |> Ecto.Changeset.change(attrs)
        |> Repo.insert
      {:new, area_level2}
    end
  end
end
