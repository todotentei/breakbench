defmodule Breakbench.Repo.Migrations.CreateFunctionFieldDailyOpeningHours do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION daily_opening_hours (
        _field_id CHARACTER VARYING (255),
        _date DATE
      ) RETURNS int4range[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _dow INTEGER;
        _opr RECORD;
        _oph int4range;
        _csh int4range[];
        _tmp int4range[];
        _rtn int4range[];
      BEGIN
        SELECT DATE_PART('ISODOW', _date::DATE)
        INTO _dow;

        FOR _opr IN
          SELECT
            tbk.start_time,
            tbk.end_time
          FROM spaces AS spc
          INNER JOIN fields AS fld ON
            spc.id = fld.space_id
          INNER JOIN space_opening_hours AS soh ON
            spc.id = soh.space_id
          LEFT OUTER JOIN time_blocks AS tbk ON
            tbk.id = soh.time_block_id AND
            tbk.day_of_week = _dow AND
            _date <@ daterange(tbk.from_date, tbk.through_date, '[]')
          WHERE
            fld.id = _field_id
        LOOP
          _oph = int4range(_opr.start_time, _opr.end_time, '[]');
          _tmp = ARRAY_APPEND(_tmp, _oph);

          SELECT
            ARRAY_AGG(int4range(tbk.start_time, tbk.end_time, '[]'))
          FROM fields AS fld
          INNER JOIN field_closing_hours AS fch ON
            fld.id = fch.field_id
          LEFT OUTER JOIN time_blocks AS tbk ON
            tbk.id = fch.time_block_id AND
            tbk.day_of_week = _dow AND
            _date <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
            _oph && int4range(tbk.start_time, tbk.end_time, '[]')
          WHERE fld.id = _field_id
          INTO _csh;

          _rtn = ARRAY_CAT(_rtn, split(_tmp, _csh));
        END LOOP;

        RETURN _rtn;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION daily_opening_hours ( CHARACTER VARYING, DATE )"
  end
end
