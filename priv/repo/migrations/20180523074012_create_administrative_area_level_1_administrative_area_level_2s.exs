defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel1AdministrativeAreaLevel2s do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_1_administrative_area_level_2s, primary_key: false) do
      add :administrative_area_level_1_id, references(:administrative_area_level_1s,
        on_delete: :delete_all, name: :area_level_1_area_level_2s_area_level_1_id),
        null: false
      add :administrative_area_level_2_id, references(:administrative_area_level_2s,
        on_delete: :delete_all, name: :area_level_1_area_level_2s_area_level_2_id),
        null: false
    end

    create index(:administrative_area_level_1_administrative_area_level_2s, [:administrative_area_level_1_id],
      name: :area_level_1_area_level_2s_area_level_1_id)

    create unique_index(:administrative_area_level_1_administrative_area_level_2s, [:administrative_area_level_2_id],
      name: :area_level_1_area_level_2s_area_level_2_id)
  end
end
