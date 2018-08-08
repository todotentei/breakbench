defmodule Breakbench.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false

      timestamps()
    end

    create index(:matches, [:game_mode_id])
  end
end
