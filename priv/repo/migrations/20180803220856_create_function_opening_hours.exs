defmodule Breakbench.Repo.Migrations.CreateFunctionOpeningHours do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _lower DATE,
        _upper DATE
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _dow INTEGER;
        _dte DATE;
        _oph int4range;
        _tsr tsrange;
        _csh int4range[]; _tmp int4range[];
        _pre tsrange[]; _rtn tsrange[];
      BEGIN
        FOR _tsr IN
          SELECT tsrange
          FROM tsgenerate(_lower::TIMESTAMP, _upper::TIMESTAMP)
        LOOP
          _tmp = '{}';
          _dte = lower(_tsr)::DATE;
          _dow = DATE_PART('ISODOW', _dte);

          FOR _oph IN
            SELECT
              int4range(tbk.start_time, tbk.end_time, '[)')
            FROM spaces AS spc
            INNER JOIN fields AS fld ON
              spc.id = fld.space_id
            INNER JOIN space_opening_hours AS soh ON
              spc.id = soh.space_id
            LEFT OUTER JOIN time_blocks AS tbk ON
              tbk.id = soh.time_block_id AND
              _dte <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
              int4range(
                EXTRACT(EPOCH FROM lower(_tsr)::TIME)::INTEGER,
                EXTRACT(EPOCH FROM upper(_tsr) - lower(_tsr)::DATE)::INTEGER,
              '[)') && int4range(tbk.start_time, tbk.end_time, '[)')
            WHERE
              tbk.day_of_week = _dow AND
              fld.id = _field_id
          LOOP
            _tmp = ARRAY_APPEND(_tmp, _oph);

            SELECT
              ARRAY_AGG(int4range(tbk.start_time, tbk.end_time, '[)'))
            FROM fields AS fld
            INNER JOIN field_closing_hours AS fch ON
              fld.id = fch.field_id
            LEFT OUTER JOIN time_blocks AS tbk ON
              tbk.id = fch.time_block_id AND
              _dte <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
              _oph && int4range(tbk.start_time, tbk.end_time, '[)')
            WHERE
              tbk.day_of_week = _dow AND
              fld.id = _field_id
            INTO _csh;

            IF _csh IS NOT NULL THEN
              _tmp = split(_tmp, _csh);
            END IF;

            SELECT ARRAY_AGG ( tsrange (
              (_dte::DATE + lower(_t) * INTERVAL '1 SEC')::TIMESTAMP,
              (_dte::DATE + upper(_t) * INTERVAL '1 SEC')::TIMESTAMP,
            '[)'))
            FROM UNNEST(_tmp) as _t
            INTO _pre;

            _rtn = ARRAY_CAT(_rtn, _pre);
          END LOOP;
        END LOOP;

        RETURN tsconnect(_rtn);
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _date DATE
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN opening_hours(_field_id, _date, (_date + INTERVAL '1 DAY')::DATE);
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION opening_hours (
        _field_id CHARACTER VARYING(255),
        _repeat INTERVAL DEFAULT '1 DAY'::INTERVAL
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN opening_hours(_field_id, now()::DATE, (now()::DATE + _repeat)::DATE);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, DATE, DATE )"
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, DATE )"
    execute "DROP FUNCTION opening_hours ( CHARACTER VARYING, INTERVAL )"
  end
end
