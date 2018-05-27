defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel2Localities do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_2_localities, primary_key: false) do
      add :administrative_area_level_2_id, references(:administrative_area_level_2s,
        on_delete: :delete_all, name: :area_level_2_localities_area_level_2_id),
        null: false
      add :locality_id, references(:localities,
        on_delete: :delete_all, name: :area_level_2_localities_locality_id),
        null: false
    end

    create index(:administrative_area_level_2_localities, [:administrative_area_level_2_id],
      name: :area_level_2_localities_area_level_2_id)

    create unique_index(:administrative_area_level_2_localities, [:locality_id],
      name: :area_level_2_localities_locality_id)
  end
end
