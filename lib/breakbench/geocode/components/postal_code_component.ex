defmodule Breakbench.Geocode.PostalCodeComponent do
  use Breakbench.Geocode.ComponentBehaviour

  alias Breakbench.Geocode.{
    AdministrativeAreaLevel1Component, ColloquialAreaComponent,
    AdministrativeAreaLevel2Component, LocalityComponent
  }
  alias Breakbench.AddressComponents.{
    Country, PostalCode, AdministrativeAreaLevel1PostalCodes,
    ColloquialAreaPostalCodes, AdministrativeAreaLevel2PostalCodes,
    PostalCodeLocalities
  }


  address_component :postal_code,
    belongs_to: :country

  belongs_to AdministrativeAreaLevel1Component,
    join_through: AdministrativeAreaLevel1PostalCodes
  belongs_to ColloquialAreaComponent,
    join_through: ColloquialAreaPostalCodes
  belongs_to AdministrativeAreaLevel2Component,
    join_through: AdministrativeAreaLevel2PostalCodes

  has_many LocalityComponent,
    join_through: PostalCodeLocalities

  @doc """
  Resolve postal_code
  """
  def resolve(%Country{} = country, %__MODULE__{} = component) do
    attrs = __MODULE__.data(component)
    with %PostalCode{} = postal_code <- country
           |> Ecto.assoc(:postal_codes)
           |> where(^Enum.to_list(attrs))
           |> Repo.one
    do
      {:old, postal_code}
    else _ ->
      {:ok, postal_code} = country
        |> Ecto.build_assoc(:postal_codes)
        |> Ecto.Changeset.change(attrs)
        |> Repo.insert
      {:new, postal_code}
    end
  end
end
