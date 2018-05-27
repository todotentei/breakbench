defmodule Breakbench.AddressComponents.AdministrativeAreaLevel1ColloquialAreas do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_1_colloquial_areas" do
    belongs_to :administrative_area_level_1, Breakbench.AddressComponents.AdministrativeAreaLevel1
    belongs_to :colloquial_area, Breakbench.AddressComponents.ColloquialArea
  end

  @doc false
  def changeset(administrative_area_level1_colloquial_areas, attrs) do
    administrative_area_level1_colloquial_areas
    |> cast(attrs, [:administrative_area_level_1_id, :colloquial_area_id])
    |> foreign_key_constraint(:administrative_area_level_1_id,
         name: :area_level_1_colloquial_areas_area_level_1_id)
    |> foreign_key_constraint(:colloquial_area_id,
         name: :area_level_1_colloquial_areas_colloquial_area_id)
    |> unique_constraint(:colloquial_area_id,
         name: :area_level_1_colloquial_areas_colloquial_area_id)
  end
end
