defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapGameAreaClosingHour do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_game_area_closing_hour()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tb time_blocks;
      BEGIN
        SELECT * FROM time_blocks AS tbk
        WHERE tbk.id = NEW.time_block_id
        INTO _tb;

        IF EXISTS (
          SELECT * FROM game_area_closing_hours AS gac
          JOIN time_blocks AS tbk ON tbk.id = gac.time_block_id
          WHERE
            gac.game_area_id = NEW.game_area_id AND
            tbk.day_of_week = _tb.day_of_week AND
            int4range(_tb.start_time, _tb.end_time, '[)') && int4range(tbk.start_time, tbk.end_time, '[)') AND
            daterange(_tb.from_date, _tb.through_date, '[)') && daterange(tbk.from_date, tbk.through_date, '[)')
        ) THEN
          RAISE EXCEPTION 'error overlap game area closing hour';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_game_area_closing_hour
      BEFORE
        INSERT OR
        UPDATE
      ON game_area_closing_hours
        FOR EACH ROW
          EXECUTE PROCEDURE
            overlap_game_area_closing_hour();
    """
  end

  def down do
    execute "DROP TRIGGER overlap_game_area_closing_hour ON game_area_closing_hours"
    execute "DROP FUNCTION overlap_game_area_closing_hour ( )"
  end
end
