defmodule Breakbench.Repo.Migrations.CreateColloquialAreas do
  use Ecto.Migration

  def change do
    create table(:colloquial_areas) do
      add :short_name, :citext, null: false
      add :long_name, :citext, null: false
      add :country_short_name, references(:countries, on_delete: :delete_all,
        column: :short_name, type: :citext), null: false

      timestamps()
    end

    create index(:colloquial_areas, [:country_short_name])
    create unique_index(:colloquial_areas, [:country_short_name, :long_name])
  end
end
