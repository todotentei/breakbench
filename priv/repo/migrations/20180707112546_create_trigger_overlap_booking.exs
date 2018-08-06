defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapBooking do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_booking()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      BEGIN
        IF EXISTS (
          SELECT *
          FROM bookings AS bkn
          WHERE
            bkn.field_id = NEW.field_id AND
            tsrange(NEW.kickoff, NEW.kickoff + NEW.duration * INTERVAL '1 SEC', '[)')
              && tsrange(bkn.kickoff, bkn.kickoff + bkn.duration * INTERVAL '1 SEC', '[)')
        ) THEN
          RAISE EXCEPTION 'error overlap booking';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_booking
      BEFORE INSERT
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
