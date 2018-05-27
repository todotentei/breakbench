defmodule Breakbench.Repo.Migrations.CreatePostalCodeLocalities do
  use Ecto.Migration

  def change do
    create table(:postal_code_localities, primary_key: false) do
      add :postal_code_id, references(:postal_codes,
        on_delete: :delete_all), null: false
      add :locality_id, references(:localities,
        on_delete: :delete_all), null: false
    end

    create index(:postal_code_localities, [:postal_code_id])

    create unique_index(:postal_code_localities, [:locality_id])
  end
end
