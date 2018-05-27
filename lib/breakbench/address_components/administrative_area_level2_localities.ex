defmodule Breakbench.AddressComponents.AdministrativeAreaLevel2Localities do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_2_localities" do
    belongs_to :administrative_area_level_2, Breakbench.AddressComponents.AdministrativeAreaLevel2
    belongs_to :locality, Breakbench.AddressComponents.Locality
  end

  @doc false
  def changeset(administrative_area_level2_localities, attrs) do
    administrative_area_level2_localities
    |> cast(attrs, [:administrative_area_level_2_id, :locality_id])
    |> foreign_key_constraint(:administrative_area_level_2_id,
         name: :area_level_2_localities_area_level_2_id)
    |> foreign_key_constraint(:locality_id,
         name: :area_level_2_localities_locality_id)
    |> unique_constraint(:locality_id,
         name: :area_level_2_localities_locality_id)
  end
end
