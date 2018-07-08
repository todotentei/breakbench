defmodule Breakbench.Repo.Migrations.CreateTriggerIntersectBooking do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION intersect_booking()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        intersected BOOLEAN;
      BEGIN
        SELECT EXISTS (
          SELECT * FROM bookings AS bkn
          WHERE
            bkn.field_id = NEW.field_id AND
            NOT (
              NEW.kickoff >= shift_datetime_by_minutes(bkn.kickoff, bkn.duration) OR
              bkn.kickoff >= shift_datetime_by_minutes(NEW.kickoff, NEW.duration)
            )
        ) INTO intersected;

        IF intersected THEN
          RAISE EXCEPTION 'error intersect booking';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER intersect_booking
      BEFORE
        INSERT OR
        UPDATE
      ON bookings
        FOR EACH ROW
          EXECUTE PROCEDURE
            intersect_booking();
    """
  end

  def down do
    execute "DROP TRIGGER intersect_booking ON bookings"
    execute "DROP FUNCTION intersect_booking ( )"
  end
end
