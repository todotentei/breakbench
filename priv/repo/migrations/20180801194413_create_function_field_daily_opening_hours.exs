defmodule Breakbench.Repo.Migrations.CreateFunctionFieldDailyOpeningHours do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION daily_opening_hours (
        _field_id CHARACTER VARYING (255),
        _date DATE
      ) RETURNS time_range [] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _dowiso INTEGER;
        _opening_record RECORD;
        _opening_hour time_range;
        _closing_hours time_range [];
        _temp time_range [];
        _return time_range [];
      BEGIN
        SELECT DATE_PART('ISODOW', _date::DATE)
        INTO _dowiso;

        FOR _opening_record IN
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
            tbk.day_of_week = _dowiso AND
            overlap (
              (_date, _date)::date_range,
              (tbk.from_date, tbk.through_date)::date_range
            )
          WHERE
            fld.id = _field_id
        LOOP
          _opening_hour = (
            _opening_record.start_time,
            _opening_record.end_time
          )::time_range;
          _temp = ARRAY_APPEND(_temp, _opening_hour::time_range);

          SELECT
            ARRAY_AGG((tbk.start_time, tbk.end_time)::time_range)
          FROM fields AS fld
          INNER JOIN field_closing_hours AS fch ON
            fld.id = fch.field_id
          LEFT OUTER JOIN time_blocks AS tbk ON
            tbk.id = fch.time_block_id AND
            tbk.day_of_week = _dowiso AND
            overlap (
              (_date, _date)::date_range,
              (tbk.from_date, tbk.through_date)::date_range
            ) AND
            overlap (
              _opening_hour::time_range,
              (tbk.start_time, tbk.end_time)::time_range
            )
          WHERE fld.id = _field_id
          INTO _closing_hours;

          SELECT split(_temp, _closing_hours)
          INTO _temp;

          _return = ARRAY_CAT(_return, _temp);
        END LOOP;

        RETURN _return;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION daily_opening_hours ( CHARACTER VARYING, DATE )"
  end
end
