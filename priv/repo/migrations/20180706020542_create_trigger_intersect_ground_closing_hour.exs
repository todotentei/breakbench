defmodule Breakbench.Repo.Migrations.CreateTriggerIntersectGroundClosingHour do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION intersect_ground_closing_hour()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        new_time_block time_blocks;
        new_time_span time_span;
        new_valid_period valid_period;
        intersected BOOLEAN;
      BEGIN
        SELECT * FROM time_blocks AS tbk
        INTO new_time_block
        WHERE tbk.id = NEW.time_block_id;

        new_time_span = (new_time_block.start_at, new_time_block.end_at)::time_span;
        new_valid_period = (new_time_block.valid_from, new_time_block.valid_through)::valid_period;

        SELECT EXISTS (
          SELECT * FROM ground_closing_hours AS gch
          JOIN time_blocks AS tbk ON tbk.id = gch.time_block_id
          WHERE
            gch.ground_id = NEW.ground_id AND
            tbk.day_of_week = new_time_block.day_of_week AND
            is_time_span_intersect(
              (tbk.start_at, tbk.end_at)::time_span,
              new_time_span
            ) AND
            not(is_time_span_touch(
              (tbk.start_at, tbk.end_at)::time_span,
              new_time_span
            )) AND
            is_valid_period_intersect(
              (tbk.valid_from, tbk.valid_through)::valid_period,
              new_valid_period
            ) AND
            not(is_valid_period_touch(
              (tbk.valid_from, tbk.valid_through)::valid_period,
              new_valid_period
            ))
        ) INTO intersected;

        IF intersected THEN
          RAISE EXCEPTION 'error intersect space opening hour';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER intersect_ground_closing_hour
      BEFORE
        INSERT OR
        UPDATE
      ON ground_closing_hours
        FOR EACH ROW
          EXECUTE PROCEDURE
            intersect_ground_closing_hour();
    """
  end

  def down do
    execute "DROP TRIGGER intersect_ground_closing_hour ON ground_closing_hours"
    execute "DROP FUNCTION intersect_ground_closing_hour ( )"
  end
end
