defmodule Breakbench.Repo.Migrations.CreateFunctionTsdaily do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tsdaily (
        _tsrange tsrange
      ) RETURNS TABLE(tsrange tsrange) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          tsrange(_tsrange.start, _tsrange.end)
        FROM (
          SELECT
            CASE WHEN stime::DATE = d THEN stime ELSE d END AS start,
            CASE WHEN etime::DATE = d THEN etime ELSE d + 1 END AS end
          FROM (
            SELECT
              stime,
              etime,
              GENERATE_SERIES(stime::DATE, etime::DATE, '1 DAY'::INTERVAL)::DATE AS d
            FROM (
              SELECT
                lower(_tsrange)::TIMESTAMP(0) AS stime,
                upper(_tsrange)::TIMESTAMP(0) AS etime
            ) AS _series
          ) AS _start_end
          ORDER BY stime
        ) AS _tsrange
        WHERE _tsrange.start < _tsrange.end;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tsdaily ( tsrange )"
  end
end
