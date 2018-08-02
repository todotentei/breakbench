defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapSpaceOpeningHour do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_space_opening_hour()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        new_time_block time_blocks;
        new_time_range time_range;
        new_date_range date_range;
        overlapped BOOLEAN;
      BEGIN
        SELECT * FROM time_blocks AS tbk
        INTO new_time_block
        WHERE tbk.id = NEW.time_block_id;

        new_time_range = (new_time_block.start_time, new_time_block.end_time)::time_range;
        new_date_range = (new_time_block.from_date, new_time_block.through_date)::date_range;

        SELECT EXISTS (
          SELECT * FROM space_opening_hours AS sph
          JOIN time_blocks AS tbk ON tbk.id = sph.time_block_id
          WHERE
            sph.space_id = NEW.space_id AND
            tbk.day_of_week = new_time_block.day_of_week AND
            overlap(
              (tbk.start_time, tbk.end_time)::time_range,
              new_time_range
            ) AND
            not(touch (
              (tbk.start_time, tbk.end_time)::time_range,
              new_time_range
            )) AND
            overlap(
              (tbk.from_date, tbk.through_date)::date_range,
              new_date_range
            ) AND
            not(touch (
              (tbk.from_date, tbk.through_date)::date_range,
              new_date_range
            ))
        ) INTO overlapped;

        IF overlapped THEN
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
