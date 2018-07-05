defmodule Breakbench.Repo.Migrations.CreateFunctionTimeSpanComparison do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION is_time_span_intersect(
        time_span0 time_span,
        time_span1 time_span
      ) RETURNS BOOLEAN LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN NOT (
          (time_span0.start_at > time_span1.end_at) OR
          (time_span1.start_at > time_span0.end_at)
        );
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION is_time_span_touch(
        time_span0 time_span,
        time_span1 time_span
      ) RETURNS BOOLEAN LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN (
          (time_span0.start_at = time_span1.end_at) OR
          (time_span1.start_at = time_span0.end_at)
        );
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION is_time_span_intersect ( time_span, time_span )"
    execute "DROP FUNCTION is_time_span_touch ( time_span, time_span )"
  end
end
