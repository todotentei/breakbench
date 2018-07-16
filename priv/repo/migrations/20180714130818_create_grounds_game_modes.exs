defmodule Breakbench.Repo.Migrations.CreateGroundsGameModes do
  use Ecto.Migration

  def change do
    create table(:grounds_game_modes) do
      add :ground_id, references(:grounds, on_delete: :delete_all, type: :string),
        null: false
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false

      timestamps()
    end

    create index(:grounds_game_modes, [:ground_id])
    create index(:grounds_game_modes, [:game_mode_id])

    create unique_index(:grounds_game_modes, [:ground_id, :game_mode_id])
  end
end
