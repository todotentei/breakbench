defmodule Breakbench.AddressComponents.AdministrativeAreaLevel1AdministrativeAreaLevel2s do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_1_administrative_area_level_2s" do
    belongs_to :administrative_area_level_1, Breakbench.AddressComponents.AdministrativeAreaLevel1
    belongs_to :administrative_area_level_2, Breakbench.AddressComponents.AdministrativeAreaLevel2
  end

  @doc false
  def changeset(administrative_area_level1_administrative_area_level2s, attrs) do
    administrative_area_level1_administrative_area_level2s
    |> cast(attrs, [:administrative_area_level_1_id, :administrative_area_level_2_id])
    |> foreign_key_constraint(:administrative_area_level_1_id,
         name: :area_level_1_area_level_2s_area_level_1_id)
    |> foreign_key_constraint(:administrative_area_level_2_id,
         name: :area_level_1_area_level_2s_area_level_2_id)
    |> unique_constraint(:administrative_area_level_2,
         name: :area_level_1_area_level_2s_area_level_2_id)
  end
end
