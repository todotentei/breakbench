defmodule Breakbench.Repo.Migrations.CreateColloquialAreaAdministrativeAreaLevel2s do
  use Ecto.Migration

  def change do
    create table(:colloquial_area_administrative_area_level_2s, primary_key: false) do
      add :colloquial_area_id, references(:colloquial_areas,
        on_delete: :delete_all, name: :colloquial_area_area_level_2s_colloquial_area_id),
        null: false
      add :administrative_area_level_2_id, references(:administrative_area_level_2s,
        on_delete: :delete_all, name: :colloquial_area_area_level_2s_area_level_2_id),
        null: false
    end

    create index(:colloquial_area_administrative_area_level_2s, [:colloquial_area_id],
      name: :colloquial_area_area_level_2s_colloquial_area_id)

    create unique_index(:colloquial_area_administrative_area_level_2s, [:administrative_area_level_2_id],
      name: :colloquial_area_area_level_2s_area_level_2_id)
  end
end
