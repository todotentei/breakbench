defmodule Breakbench.Repo.Migrations.CreateMatchmakingQueues do
  use Ecto.Migration

  def change do
    create table(:matchmaking_queues, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :geom, :"geometry(point,4326)"
      add :kickoff_from, :naive_datetime
      add :kickoff_through, :naive_datetime
      add :travel_mode, :string
      add :mood, :string
      add :status, :string

      timestamps()
    end

    create index(:matchmaking_queues, [:geom], using: :gist)
    create index(:matchmaking_queues, [:travel_mode])
    create index(:matchmaking_queues, [:mood])
    create index(:matchmaking_queues, [:status])
  end
end
