defmodule Breakbench.Repo.Migrations.CreatePostalCodes do
  use Ecto.Migration

  def change do
    create table(:postal_codes) do
      add :short_name, :citext, null: false
      add :long_name, :citext, null: false
      add :country_short_name, references(:countries, on_delete: :delete_all,
        column: :short_name, type: :citext), null: false

      timestamps()
    end

    create index(:postal_codes, [:country_short_name])
    create unique_index(:postal_codes, [:country_short_name, :long_name])
  end
end
