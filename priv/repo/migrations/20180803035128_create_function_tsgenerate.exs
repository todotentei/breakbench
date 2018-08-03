defmodule Breakbench.Repo.Migrations.CreateFunctionTsgenerate do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tsgenerate (
        _lower TIMESTAMP WITHOUT TIME ZONE,
        _upper TIMESTAMP WITHOUT TIME ZONE,
        _step INTERVAL DEFAULT '1 DAY'::INTERVAL
      ) RETURNS TABLE(tsrange tsrange) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          tsrange (
            CASE WHEN stime::DATE = d THEN stime ELSE d END,
            CASE WHEN etime::DATE = d THEN etime ELSE d + 1 END
          )
        FROM (
          SELECT stime
               , etime
               , GENERATE_SERIES(stime::DATE, etime::DATE, _step::INTERVAL)::DATE AS d
          FROM (
            SELECT _lower::TIMESTAMP(0) AS stime
                 , _upper::TIMESTAMP(0) AS etime
          ) sub1
        ) sub0
        ORDER BY stime;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tsgenerate ( TIMESTAMP WITHOUT TIME ZONE, TIMESTAMP WITHOUT TIME ZONE, INTERVAL )"
  end
end
