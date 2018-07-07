defmodule Breakbench.Repo.Migrations.CreateGroundsSports do
  use Ecto.Migration

  def change do
    create table(:grounds_sports) do
      add :ground_id, references(:grounds, on_delete: :delete_all, type: :string),
        null: false
      add :sport_name, references(:sports, on_delete: :delete_all, column: :name, type: :citext),
        null: false

      timestamps()
    end

    create index(:grounds_sports, [:ground_id])
    create index(:grounds_sports, [:sport_name])

    create unique_index(:grounds_sports, [:ground_id, :sport_name])
  end
end
