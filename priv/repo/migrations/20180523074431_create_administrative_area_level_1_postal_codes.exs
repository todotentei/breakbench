defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel1PostalCodes do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_1_postal_codes, primary_key: false) do
      add :administrative_area_level_1_id, references(:administrative_area_level_1s,
        on_delete: :delete_all, name: :area_level_1_postal_codes_area_level_1_id),
        null: false
      add :postal_code_id, references(:postal_codes,
        on_delete: :delete_all, name: :area_level_1_postal_codes_postal_code_id),
        null: false
    end

    create index(:administrative_area_level_1_postal_codes, [:administrative_area_level_1_id],
      name: :area_level_1_postal_codes_area_level_1_id)

    create unique_index(:administrative_area_level_1_postal_codes, [:postal_code_id],
      name: :area_level_1_postal_codes_postal_code_id)
  end
end
