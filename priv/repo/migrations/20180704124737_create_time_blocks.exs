defmodule Breakbench.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :day_of_week, :integer
      add :start_time, :time
      add :end_time, :time
      add :from_date, :date
      add :through_date, :date
    end

    create index(:time_blocks, [:day_of_week])
  end
end
