defmodule Breakbench.Repo.Migrations.CreateFunctionExtractDate do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION extract_date (
        _tsranges tsrange[]
      ) RETURNS DATE[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _rtn DATE[];
      BEGIN
        WITH oph AS (
          SELECT _oph::tsrange
          FROM UNNEST(_tsranges) AS _oph
        )
        SELECT ARRAY_AGG(_dte.timestamp::DATE)
        INTO _rtn
        FROM (
          SELECT
            GENERATE_SERIES(lower(_oph), upper(_oph), '1 DAY') AS timestamp
          FROM oph AS _oph
        ) AS _dte
        RIGHT JOIN oph ON
          _dte.timestamp <@ oph._oph;

        RETURN _rtn;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION extract_date ( tsrange[] )"
  end
end
