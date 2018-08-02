defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapBooking do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_booking()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        overlapped BOOLEAN;
      BEGIN
        SELECT EXISTS (
          SELECT * FROM bookings AS bkn
          WHERE
            bkn.field_id = NEW.field_id AND
            NOT (
              NEW.kickoff >= shift_datetime_by_minutes(bkn.kickoff, bkn.duration) OR
              bkn.kickoff >= shift_datetime_by_minutes(NEW.kickoff, NEW.duration)
            )
        ) INTO overlapped;

        IF overlapped THEN
          RAISE EXCEPTION 'error overlap booking';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_booking
      BEFORE
        INSERT OR
        UPDATE
      ON bookings
        FOR EACH ROW
          EXECUTE PROCEDURE
            overlap_booking();
    """
  end

  def down do
    execute "DROP TRIGGER overlap_booking ON bookings"
    execute "DROP FUNCTION overlap_booking ( )"
  end
end
