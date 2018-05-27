defmodule Breakbench.Repo.Migrations.CreateColloquialAreaPostalCodes do
  use Ecto.Migration

  def change do
    create table(:colloquial_area_postal_codes, primary_key: false) do
      add :colloquial_area_id, references(:colloquial_areas,
        on_delete: :delete_all), null: false
      add :postal_code_id, references(:postal_codes,
        on_delete: :delete_all), null: false
    end

    create index(:colloquial_area_postal_codes, [:colloquial_area_id])

    create unique_index(:colloquial_area_postal_codes, [:postal_code_id])
  end
end
