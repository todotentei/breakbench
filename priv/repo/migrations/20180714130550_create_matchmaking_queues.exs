defmodule Breakbench.Repo.Migrations.CreateMatchmakingQueues do
  use Ecto.Migration

  def change do
    create table(:matchmaking_queues, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :geom, :"geometry(point,4326)"
      add :status, :string
      add :lock_version, :integer, default: 1

      timestamps()
    end

    create index(:matchmaking_queues, [:geom], using: :gist)
    create index(:matchmaking_queues, [:status])
  end
end
