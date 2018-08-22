defmodule Breakbench.Repo.Migrations.CreateMatchmakingSpaceDistanceMatrices do
  use Ecto.Migration

  def change do
    create table(:matchmaking_space_distance_matrices, primary_key: false) do
      add :distance, :integer
      add :duration, :integer
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string)
      add :matchmaking_queue_id, references(:matchmaking_queues, on_delete: :delete_all, type: :uuid)
    end

    create index(:matchmaking_space_distance_matrices, [:space_id])
    create index(:matchmaking_space_distance_matrices, [:matchmaking_queue_id])

    create unique_index(:matchmaking_space_distance_matrices, [:space_id, :matchmaking_queue_id])
  end
end
