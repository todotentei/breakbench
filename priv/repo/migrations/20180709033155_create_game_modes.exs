defmodule Breakbench.Repo.Migrations.CreateGameModes do
  use Ecto.Migration

  def change do
    create table(:game_modes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :number_of_players, :integer, null: false
      add :duration, :integer
      add :sport_name, references(:sports, on_delete: :delete_all, column: :name, type: :citext),
        null: false

      timestamps()
    end

    create index(:game_modes, [:sport_name])
  end
end
