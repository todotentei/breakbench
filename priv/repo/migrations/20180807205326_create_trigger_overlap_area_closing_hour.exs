defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapAreaClosingHour do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_area_closing_hour()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tb time_blocks;
      BEGIN
        SELECT * INTO _tb
        FROM time_blocks AS tbk
        WHERE tbk.id = NEW.time_block_id;

        IF EXISTS (
          SELECT TRUE
          FROM area_closing_hours AS ach
          JOIN time_blocks AS tbk ON
            tbk.id = ach.time_block_id
          WHERE
            ach.area_id = NEW.area_id AND
            tbk.day_of_week = _tb.day_of_week AND
            int4range(_tb.start_time, _tb.end_time, '[)') && int4range(tbk.start_time, tbk.end_time, '[)') AND
            daterange(_tb.from_date, _tb.through_date, '[)') && daterange(tbk.from_date, tbk.through_date, '[)')
        ) THEN
          RAISE EXCEPTION 'error overlap area closing hour';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_area_closing_hour
      BEFORE INSERT
      ON area_closing_hours
        FOR EACH ROW
          EXECUTE PROCEDURE
            overlap_area_closing_hour();
    """
  end

  def down do
    execute "DROP TRIGGER overlap_area_closing_hour ON area_closing_hours"
    execute "DROP FUNCTION overlap_area_closing_hour ( )"
  end
end
