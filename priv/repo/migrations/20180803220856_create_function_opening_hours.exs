defmodule Breakbench.Repo.Migrations.CreateFunctionOpeningHours do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _tsrange tsrange
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _date DATE;
        _day_of_week INTEGER;
        _tschunk tsrange;
        _lower_chunk INTEGER;
        _upper_chunk INTEGER;
        _opening_hour int4range;
        _closing_hours int4range[];
        _temp int4range[];
        _pre_return tsrange[];
        _return tsrange[];
      BEGIN
        FOR _tschunk IN
          SELECT tsrange
          FROM tsgenerate(_tsrange)
        LOOP
          _temp = '{}';
          _date = lower(_tschunk)::DATE;
          _day_of_week = DATE_PART('ISODOW', _date);

          _lower_chunk = EXTRACT(EPOCH FROM lower(_tschunk)::TIME)::INTEGER;
          _upper_chunk = EXTRACT(EPOCH FROM upper(_tschunk)::TIME)::INTEGER;

          FOR _opening_hour IN
            SELECT
              int4range(tbk.start_time, tbk.end_time, '[)')
            FROM spaces AS spc
            INNER JOIN areas ON
              spc.id = areas.space_id
            INNER JOIN fields AS fld ON
              areas.id = fld.area_id
            INNER JOIN space_opening_hours AS soh ON
              spc.id = soh.space_id
            LEFT OUTER JOIN time_blocks AS tbk ON
              tbk.id = soh.time_block_id AND
              _date <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
              int4range(_lower_chunk, CASE WHEN _upper_chunk = 0 THEN 86400 ELSE _upper_chunk END, '[)')
                && int4range(tbk.start_time, tbk.end_time, '[)')
            WHERE
              tbk.day_of_week = _day_of_week AND
              fld.id = _field_id
          LOOP
            _temp = ARRAY_APPEND(_temp, _opening_hour);

            SELECT ARRAY_AGG(int4range)
            INTO _closing_hours
            FROM (
              SELECT
                int4range(tbk.start_time, tbk.end_time, '[)')
              FROM areas
              INNER JOIN fields AS fld ON
                areas.id = fld.area_id
              INNER JOIN area_closing_hours AS ach ON
                areas.id = ach.area_id
              LEFT OUTER JOIN time_blocks AS tbk ON
                tbk.id = ach.time_block_id AND
                _date <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
                _opening_hour && int4range(tbk.start_time, tbk.end_time, '[)')
              WHERE
                tbk.day_of_week = _day_of_week AND
                fld.id = _field_id

              UNION

              SELECT
                int4range(tbk.start_time, tbk.end_time, '[)')
              FROM fields AS fld
              INNER JOIN field_closing_hours AS fch ON
                fld.id = fch.field_id
              LEFT OUTER JOIN time_blocks AS tbk ON
                tbk.id = fch.time_block_id AND
                _date <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
                _opening_hour && int4range(tbk.start_time, tbk.end_time, '[)')
              WHERE
                tbk.day_of_week = _day_of_week AND
                fld.id = _field_id
            ) AS _all_closing_hours;

            IF _closing_hours IS NOT NULL THEN
              _temp = split(_temp, _closing_hours);
            END IF;

            SELECT ARRAY_AGG(
              tsrange (
                (_date::DATE + lower(_t) * INTERVAL '1 SEC')::TIMESTAMP,
                (_date::DATE + upper(_t) * INTERVAL '1 SEC')::TIMESTAMP,
              '[)')
            )
            INTO _pre_return
            FROM UNNEST(_temp) as _t;

            _return = ARRAY_CAT(_return, _pre_return);
          END LOOP;
        END LOOP;

        SELECT
          ARRAY_AGG(CASE WHEN _tsrange @> _r THEN _r ELSE _tsrange * _r END)
        FROM UNNEST(_return) AS _r
        WHERE _tsrange && _r
        INTO _return;

        RETURN tsconnect(_return);
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _date DATE
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tschunk tsrange;
      BEGIN
        _tschunk = tsrange(_date::DATE, (_date + INTERVAL '1 DAY')::DATE);
        RETURN opening_hours(_field_id, _tschunk);
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _repeat INTERVAL DEFAULT '1 DAY'::INTERVAL
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tschunk tsrange;
      BEGIN
        _tschunk = tsrange(now()::DATE, (now()::DATE + _repeat)::DATE);
        RETURN opening_hours(_field_id, _tschunk);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, tsrange )"
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, DATE )"
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, INTERVAL )"
  end
end
