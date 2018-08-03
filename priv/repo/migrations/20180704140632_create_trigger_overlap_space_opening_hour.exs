defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapSpaceOpeningHour do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_space_opening_hour()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tb time_blocks;
      BEGIN
        SELECT * FROM time_blocks AS tbk
        WHERE tbk.id = NEW.time_block_id
        INTO _tb;

        IF EXISTS (
          SELECT * FROM space_opening_hours AS sph
          JOIN time_blocks AS tbk ON tbk.id = sph.time_block_id
          WHERE
            sph.space_id = NEW.space_id AND
            tbk.day_of_week = _tb.day_of_week AND
            int4range(_tb.start_time, _tb.end_time, '[)') && int4range(tbk.start_time, tbk.end_time, '[)') AND
            daterange(_tb.from_date, _tb.through_date, '[)') && daterange(tbk.from_date, tbk.through_date, '[)')
        ) THEN
          RAISE EXCEPTION 'error overlap space opening hour';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_space_opening_hour
      BEFORE
        INSERT OR
        UPDATE
      ON space_opening_hours
        FOR EACH ROW
          EXECUTE PROCEDURE
            overlap_space_opening_hour();
    """
  end

  def down do
    execute "DROP TRIGGER overlap_space_opening_hour ON space_opening_hours"
    execute "DROP FUNCTION overlap_space_opening_hour ( )"
  end
end
