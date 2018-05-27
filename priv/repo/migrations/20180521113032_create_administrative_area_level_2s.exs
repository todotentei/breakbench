defmodule Breakbench.Repo.Migrations.CreateAdministrativeAreaLevel2s do
  use Ecto.Migration

  def change do
    create table(:administrative_area_level_2s) do
      add :short_name, :string, null: false
      add :long_name, :string, null: false
      add :country_short_name, references(:countries, on_delete: :delete_all,
        column: :short_name, type: :string), null: false

      timestamps()
    end

    create index(:administrative_area_level_2s, [:country_short_name])
    create unique_index(:administrative_area_level_2s,
      [:country_short_name, :long_name])
  end
end
