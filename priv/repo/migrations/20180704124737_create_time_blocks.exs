defmodule Breakbench.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :day_of_week, :integer
      add :start_time, :integer
      add :end_time, :integer
      add :from_date, :date
      add :through_date, :date
    end

    create index(:time_blocks, [:day_of_week])
    execute("CREATE INDEX time_blocks_time_range_through_index ON time_blocks USING gist (int4range(start_time,end_time,'[]'))")
    execute("CREATE INDEX time_blocks_time_range_until_index ON time_blocks USING gist (int4range(start_time,end_time,'[)'))")
    execute("CREATE INDEX time_blocks_date_range_through_index ON time_blocks USING gist (daterange(from_date,through_date,'[]'))")
    execute("CREATE INDEX time_blocks_date_range_until_index ON time_blocks USING gist (daterange(from_date,through_date,'[)'))")

    create constraint(:time_blocks, "valid_start_time", check: "start_time >= 0 AND start_time <= 86400")
    create constraint(:time_blocks, "valid_end_time", check: "end_time >= 0 AND end_time <= 86400")
    create constraint(:time_blocks, "positive_duration", check: "end_time > start_time")
  end
end
