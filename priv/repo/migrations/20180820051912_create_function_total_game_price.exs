defmodule Breakbench.Repo.Migrations.CreateFunctionTotalGamePrice do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION total_game_price(
        _game_area_id UUID,
        _kickoff TIMESTAMP WITHOUT TIME ZONE,
        _duration INTEGER
      ) RETURNS INTEGER LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN
          CEIL(SUM(_bd.duration::DECIMAL / 3600 * _bd.price_per_hour))
        FROM (
          SELECT
            (upper(_breakdown.timerange) - lower(_breakdown.timerange)) AS duration,
            _breakdown.price AS price_per_hour
          FROM (
            SELECT
              date, timerange, price
            FROM calc_game_price(
              'cf233e83-a186-42d4-a81d-e6068b7ff905',
              '2018-08-18 23:30:00'::TIMESTAMP,
              7600
            )
          ) AS _breakdown
        ) AS _bd;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION total_game_price ( UUID, TIMESTAMP WITHOUT TIME ZONE, INTEGER )"
  end
end
