defmodule Breakbench.Geocode.CountryComponent do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode.{
    AdministrativeAreaLevel1Component, ColloquialAreaComponent,
    AdministrativeAreaLevel2Component, PostalCodeComponent, LocalityComponent
  }
  alias Breakbench.AddressComponents.Country
  import Breakbench.AddressComponents, only: [
    get_country: 1, create_country: 1
  ]


  address_component :country

  has_many AdministrativeAreaLevel1Component
  has_many ColloquialAreaComponent
  has_many AdministrativeAreaLevel2Component
  has_many PostalCodeComponent
  has_many LocalityComponent

  @doc """
  Resolve country
  """
  def resolve(%__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %Country{} = country <- component
           |> Map.get(:short_name)
           |> get_country()
    do
      {:old, country}
    else _ ->
      {:ok, country} = attrs
        |> create_country()
      {:new, country}
    end
  end
end
