defmodule Breakbench.Repo.Migrations.CreateFunctionCalcGamePrice do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION calc_game_price(
        _game_area_id UUID,
        _kickoff TIMESTAMP WITHOUT TIME ZONE,
        _duration INTEGER
      ) RETURNS TABLE (
        date DATE,
        timerange int4range,
        price INTEGER
      ) LANGUAGE PLPGSQL
      AS $$
      DECLARE
        default_price INTEGER;
        dailychunk RECORD;
        temp_default pricerange[];
        temp_dynamic pricerange[];
        priceranges pricerange[];
      BEGIN
        -- Game area default price
        SELECT
          gar.default_price
        FROM game_areas AS gar
        WHERE
          gar.id = _game_area_id
        INTO default_price;

        FOR dailychunk IN
          SELECT
            tscur.date AS date,
            int4range(tscur.start_time, CASE
              WHEN tscur.end_time = 0 THEN 86400 ELSE tscur.end_time
            END, '[)') AS timerange
          FROM (
            SELECT
              LOWER(tsdaily)::DATE AS date,
              EXTRACT(EPOCH FROM lower(tsdaily)::TIME)::INTEGER AS start_time,
              EXTRACT(EPOCH FROM upper(tsdaily)::TIME)::INTEGER AS end_time
            FROM (
              SELECT tsdaily(tsrange(
                _kickoff, _kickoff + _duration * INTERVAL '1 SEC'
              ))
            ) AS tsdaily
          ) AS tscur
        LOOP
          temp_dynamic = '{}';
          temp_default = '{}';

          SELECT ARRAY_AGG(_d)
          FROM (
            SELECT
              dailychunk.date AS date,
              dailychunk.timerange * int4range(tbk.start_time, tbk.end_time, '[)') as timerange,
              gad.price AS price_per_hour
            FROM game_area_dynamic_pricings AS gad
            INNER JOIN time_blocks AS tbk ON
              tbk.id = gad.time_block_id
            WHERE
              tbk.day_of_week = DATE_PART('ISODOW', dailychunk.date) AND
              dailychunk.date <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
              dailychunk.timerange && int4range(tbk.start_time, tbk.end_time, '[)')
          ) AS _d
          INTO temp_dynamic;

          SELECT ARRAY_AGG(_d)
          FROM (
            SELECT
              dailychunk.date AS date,
              _d._split AS timerange,
              default_price AS price_per_hour
            FROM (
              SELECT
                UNNEST(split(array[dailychunk.timerange], array_agg(_d.timerange::int4range))) AS _split
              FROM json_to_recordset(array_to_json(temp_dynamic)) as _d
                ("timerange" int4range)
            ) AS _d
          ) AS _d
          INTO temp_default;

          priceranges = priceranges || temp_default || temp_dynamic;
        END LOOP;

        RETURN QUERY SELECT
          _d.date,
          _d.timerange,
          _d.price_per_hour
        FROM json_to_recordset(array_to_json(priceranges)) AS _d
          ("date" DATE, "timerange" int4range, "price_per_hour" INTEGER);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION calc_game_price ( UUID, TIMESTAMP WITHOUT TIME ZONE, INTEGER )"
  end
end
