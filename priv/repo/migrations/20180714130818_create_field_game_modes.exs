defmodule Breakbench.Repo.Migrations.CreateFieldGameModes do
  use Ecto.Migration

  def change do
    create table(:field_game_modes) do
      add :field_id, references(:fields, on_delete: :delete_all, type: :string),
        null: false
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:field_game_modes, [:field_id])
    create index(:field_game_modes, [:game_mode_id])

    create unique_index(:field_game_modes, [:field_id, :game_mode_id])
  end
end
