defmodule Breakbench.Geocode.AdministrativeAreaLevel1Component do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode.{
    ColloquialAreaComponent, AdministrativeAreaLevel2Component,
    PostalCodeComponent, LocalityComponent
  }
  alias Breakbench.AddressComponents.{
    Country, AdministrativeAreaLevel1, AdministrativeAreaLevel1ColloquialAreas,
    AdministrativeAreaLevel1AdministrativeAreaLevel2s,
    AdministrativeAreaLevel1PostalCodes, AdministrativeAreaLevel1Localities
  }

  address_component :administrative_area_level_1,
    belongs_to: :country

  has_many ColloquialAreaComponent,
    join_through: AdministrativeAreaLevel1ColloquialAreas
  has_many AdministrativeAreaLevel2Component,
    join_through: AdministrativeAreaLevel1AdministrativeAreaLevel2s
  has_many PostalCodeComponent,
    join_through: AdministrativeAreaLevel1PostalCodes
  has_many LocalityComponent,
    join_through: AdministrativeAreaLevel1Localities

  @doc """
  Resolve administrative_area_level_1
  """
  def resolve(%Country{} = country, %__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %AdministrativeAreaLevel1{} = area_level1 <- country
           |> Ecto.assoc(:administrative_area_level_1s)
           |> where(^Enum.to_list(attrs))
           |> Repo.one
    do
      {:old, area_level1}
    else _ ->
      {:ok, area_level1} = country
        |> Ecto.build_assoc(:administrative_area_level_1s)
        |> Ecto.Changeset.change(attrs)
        |> Repo.insert
      {:new, area_level1}
    end
  end
end
