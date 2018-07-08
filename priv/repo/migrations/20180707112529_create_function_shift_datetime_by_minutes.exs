defmodule Breakbench.Repo.Migrations.CreateFunctionShiftDatetimeByMinutes do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION shift_datetime_by_minutes(
        datetime TIMESTAMP WITHOUT TIME ZONE,
        duration INTEGER
      ) RETURNS TIMESTAMP WITHOUT TIME ZONE LANGUAGE PLPGSQL
      AS $$
      DECLARE
        new_datetime TIMESTAMP WITHOUT TIME ZONE;
      BEGIN
        new_datetime := datetime + duration * INTERVAL '1 MINUTE';
        RETURN new_datetime;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION shift_datetime_by_minutes ( TIMESTAMP WITHOUT TIME ZONE, INTEGER )"
  end
end
