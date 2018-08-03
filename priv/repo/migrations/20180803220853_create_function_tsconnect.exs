defmodule Breakbench.Repo.Migrations.CreateFunctionTsconnect do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tsconnect (
        _tsranges tsrange[]
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN ARRAY_AGG(_r::tsrange)
        FROM (
          SELECT tsrange(MIN(startts), MAX(endts)) AS _r
          FROM (
            SELECT *, COUNT(step) OVER (ORDER BY currentts) AS grp
            FROM (
             SELECT *, LAG(endts) OVER (ORDER BY currentts) < startts OR NULL AS step
             FROM (
              SELECT
                _t AS currentts,
                COALESCE(lower(_t),'-infinity') AS startts,
                MAX(COALESCE(upper(_t), 'infinity')) OVER (ORDER BY _t) AS endts
              FROM UNNEST(_tsranges) as _t
              ) sub3
             ) sub2
            ) sub1
          GROUP BY grp
          ORDER BY 1
        ) sub0;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tsconnect ( tsrange[] )"
  end
end
