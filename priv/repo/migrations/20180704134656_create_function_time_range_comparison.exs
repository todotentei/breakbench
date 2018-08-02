defmodule Breakbench.Repo.Migrations.CreateFunctionTimeRangeComparison do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap (
        time_range0 time_range,
        time_range1 time_range
      ) RETURNS BOOLEAN LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN NOT (
          (time_range0.start_time > time_range1.end_time) OR
          (time_range1.start_time > time_range0.end_time)
        );
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION touch (
        time_range0 time_range,
        time_range1 time_range
      ) RETURNS BOOLEAN LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN (
          (time_range0.start_time = time_range1.end_time) OR
          (time_range1.start_time = time_range0.end_time)
        );
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION overlap ( time_range, time_range )"
    execute "DROP FUNCTION touch ( time_range, time_range )"
  end
end
