defmodule Breakbench.AddressComponents.ColloquialAreaAdministrativeAreaLevel2s do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "colloquial_area_administrative_area_level_2s" do
    belongs_to :colloquial_area, Breakbench.AddressComponents.ColloquialArea
    belongs_to :administrative_area_level_2, Breakbench.AddressComponents.AdministrativeAreaLevel2
  end

  @doc false
  def changeset(colloquial_area_administrative_area_level2s, attrs) do
    colloquial_area_administrative_area_level2s
    |> cast(attrs, [:colloquial_area_id, :administrative_area_level_2_id])
    |> foreign_key_constraint(:colloquial_area_id,
         name: :colloquial_area_area_level_2s_colloquial_area_id)
    |> foreign_key_constraint(:administrative_area_level_2_id,
         name: :colloquial_area_area_level_2s_area_level_2_id)
    |> unique_constraint(:administrative_area_level_2_id,
         name: :colloquial_area_area_level_2s_area_level_2_id)
  end
end
