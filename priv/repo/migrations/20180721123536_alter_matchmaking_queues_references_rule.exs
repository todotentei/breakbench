defmodule Breakbench.Repo.Migrations.AlterMatchmakingQueuesReferencesRule do
  use Ecto.Migration

  def change do
    alter table(:matchmaking_queues) do
      add :rule_id, references(:matchmaking_rules, type: :uuid)
    end

    create index(:matchmaking_queues, [:rule_id])
  end
end
