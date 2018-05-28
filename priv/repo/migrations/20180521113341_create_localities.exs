defmodule Breakbench.Repo.Migrations.CreateLocalities do
  use Ecto.Migration

  def change do
    create table(:localities) do
      add :short_name, :citext, null: false
      add :long_name, :citext, null: false
      add :country_short_name, references(:countries, on_delete: :delete_all,
        column: :short_name, type: :citext), null: false

      timestamps()
    end

    create index(:localities, [:country_short_name])
    create unique_index(:localities, [:country_short_name, :long_name])
  end
end
