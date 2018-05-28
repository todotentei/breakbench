defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel1s do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_1s) do
      add :short_name, :citext, null: false
      add :long_name, :citext, null: false
      add :country_short_name, references(:countries, on_delete: :delete_all,
        column: :short_name, type: :citext), null: false

      timestamps()
    end

    create index(:administrative_area_level_1s, [:country_short_name])
    create unique_index(:administrative_area_level_1s,
      [:country_short_name, :long_name])
  end
end
