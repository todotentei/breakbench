defmodule Breakbench.Repo.Migrations.CreateGameAreas do
  use Ecto.Migration

  def change do
    create table(:game_areas, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string)

      timestamps()
    end

    create index(:game_areas, [:space_id])
  end
end
