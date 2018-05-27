defmodule Breakbench.Geocode.LocalityComponent do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode.{
    AdministrativeAreaLevel1Component, ColloquialAreaComponent,
    AdministrativeAreaLevel2Component, PostalCodeComponent
  }
  alias Breakbench.AddressComponents.{
    Country, Locality, AdministrativeAreaLevel1Localities, ColloquialAreaLocalities,
    AdministrativeAreaLevel2Localities, PostalCodeLocalities
  }


  address_component :locality,
    belongs_to: :country

  belongs_to AdministrativeAreaLevel1Component,
    join_through: AdministrativeAreaLevel1Localities
  belongs_to ColloquialAreaComponent,
    join_through: ColloquialAreaLocalities
  belongs_to AdministrativeAreaLevel2Component,
    join_through: AdministrativeAreaLevel2Localities
  belongs_to PostalCodeComponent,
    join_through: PostalCodeLocalities

  @doc """
  Resolve locality
  """
  def resolve(%Country{} = country, %__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %Locality{} = locality <- country
           |> Ecto.assoc(:localities)
           |> where(^Enum.to_list(attrs))
           |> Repo.one
    do
      {:old, locality}
    else _ ->
      {:ok, locality} = country
        |> Ecto.build_assoc(:localities)
        |> Ecto.Changeset.change(attrs)
        |> Repo.insert
      {:new, locality}
    end
  end
end
