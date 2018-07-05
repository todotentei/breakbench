defmodule Breakbench.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :day_of_week, :integer
      add :start_at, :time
      add :end_at, :time
      add :valid_from, :naive_datetime
      add :valid_through, :naive_datetime
    end

    create index(:time_blocks, [:day_of_week])
  end
end
