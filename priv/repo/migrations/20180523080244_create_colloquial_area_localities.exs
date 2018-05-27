defmodule Breakbench.Repo.Migrations.CreateColloquialAreaLocalities do
  use Ecto.Migration

  def change do
    create table(:colloquial_area_localities, primary_key: false) do
      add :colloquial_area_id, references(:colloquial_areas,
        on_delete: :delete_all), null: false
      add :locality_id, references(:localities,
        on_delete: :delete_all), null: false
    end

    create index(:colloquial_area_localities, [:colloquial_area_id])

    create unique_index(:colloquial_area_localities, [:locality_id])
  end
end
