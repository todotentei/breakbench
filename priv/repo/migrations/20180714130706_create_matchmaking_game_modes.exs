defmodule Breakbench.Repo.Migrations.CreateMatchmakingGameModes do
  use Ecto.Migration

  def change do
    create table(:matchmaking_game_modes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :matchmaking_queue_id, references(:matchmaking_queues, on_delete: :delete_all, type: :uuid),
        null: false
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:matchmaking_game_modes, [:matchmaking_queue_id])
    create index(:matchmaking_game_modes, [:game_mode_id])

    create unique_index(:matchmaking_game_modes, [:matchmaking_queue_id, :game_mode_id])
  end
end
