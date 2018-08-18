defmodule Breakbench.Repo.Migrations.CreateFunctionTschunk do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tschunk (
        _tsrange tsrange,
        _step INTERVAL DEFAULT '1 DAY'::INTERVAL
      ) RETURNS TABLE(tsrange tsrange) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          tsrange(_dte.start, _dte.end)
        FROM (
          SELECT
            CASE WHEN stime::DATE = d THEN stime ELSE d END AS start,
            CASE WHEN etime::DATE = d THEN etime ELSE d + 1 END AS end
          FROM (
            SELECT
              stime,
              etime,
              GENERATE_SERIES(stime::DATE, etime::DATE, _step::INTERVAL)::DATE AS d
            FROM (
              SELECT
                lower(_tsrange)::TIMESTAMP(0) AS stime,
                upper(_tsrange)::TIMESTAMP(0) AS etime
            ) sub1
          ) sub0
          ORDER BY stime
        ) AS _dte
        WHERE _dte.start < _dte.end;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tschunk ( tsrange, INTERVAL )"
  end
end
