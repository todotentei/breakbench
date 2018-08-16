defmodule Breakbench.Repo.Migrations.AlterMatchmakingQueuesAddUserId do
  use Ecto.Migration

  def change do
    alter table(:matchmaking_queues) do
      add :user_id, references(:users, on_delete: :delete_all),
        null: false
    end
  end
end
