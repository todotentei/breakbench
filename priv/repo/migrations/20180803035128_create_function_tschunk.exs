defmodule Breakbench.Repo.Migrations.CreateFunctionTschunk do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tschunk (
        _tsrange tsrange,
        _size INTERVAL DEFAULT '1 DAY'::INTERVAL
      ) RETURNS TABLE(tsrange tsrange) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          tsrange(_tsrange.start, _tsrange.end)
        FROM (
          SELECT
            CASE WHEN stimestamp = _timestamp THEN
              stimestamp
            ELSE
              _timestamp
            END AS start,
            CASE WHEN etimestamp <= _timestamp + _size::INTERVAL THEN
              etimestamp
            ELSE
              _timestamp + _size::INTERVAL
            END AS end
          FROM (
            SELECT
              stimestamp,
              etimestamp,
              GENERATE_SERIES(
                stimestamp::TIMESTAMP(0), etimestamp::TIMESTAMP(0),
                _size::INTERVAL
              )::TIMESTAMP(0) AS _timestamp
            FROM (
              SELECT
                lower(_tsrange)::TIMESTAMP(0) AS stimestamp,
                upper(_tsrange)::TIMESTAMP(0) AS etimestamp
            ) AS _series
          ) AS _start_end
          ORDER BY stimestamp
        ) AS _tsrange
        WHERE _tsrange.start < _tsrange.end;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tschunk ( tsrange, INTERVAL )"
  end
end
