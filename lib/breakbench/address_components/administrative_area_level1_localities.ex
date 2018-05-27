defmodule Breakbench.AddressComponents.AdministrativeAreaLevel1Localities do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_1_localities" do
    belongs_to :administrative_area_level_1, Breakbench.AddressComponents.AdministrativeAreaLevel1
    belongs_to :locality, Breakbench.AddressComponents.Locality
  end

  @doc false
  def changeset(administrative_area_level1_localities, attrs) do
    administrative_area_level1_localities
    |> cast(attrs, [:administrative_area_level_1_id, :locality_id])
    |> foreign_key_constraint(:administrative_area_level_1_id,
         name: :area_level_1_localities_area_level_1_id)
    |> foreign_key_constraint(:locality_id,
         name: :area_level_1_localities_locality_id)
    |> unique_constraint(:locality_id,
         name: :area_level_1_localities_locality_id)
  end
end
