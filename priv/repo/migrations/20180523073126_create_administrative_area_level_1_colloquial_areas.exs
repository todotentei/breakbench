defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel1ColloquialAreas do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_1_colloquial_areas, primary_key: false) do
      add :administrative_area_level_1_id, references(:administrative_area_level_1s,
        on_delete: :delete_all, name: :area_level_1_colloquial_areas_area_level_1_id),
        null: false
      add :colloquial_area_id, references(:colloquial_areas,
        on_delete: :delete_all, name: :area_level_1_colloquial_areas_colloquial_area_id),
        null: false
    end

    create index(:administrative_area_level_1_colloquial_areas, [:administrative_area_level_1_id],
      name: :area_level_1_colloquial_areas_area_level_1_id)

    create unique_index(:administrative_area_level_1_colloquial_areas, [:colloquial_area_id],
      name: :area_level_1_colloquial_areas_colloquial_area_id)
  end
end
