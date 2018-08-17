defmodule Breakbench.Repo.Migrations.CreateGameAreaModes do
  use Ecto.Migration

  def change do
    create table(:game_area_modes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :game_area_id, references(:game_areas, on_delete: :delete_all, type: :string),
        null: false
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:game_area_modes, [:game_area_id])
    create index(:game_area_modes, [:game_mode_id])

    create unique_index(:game_area_modes, [:game_area_id, :game_mode_id])
  end
end
