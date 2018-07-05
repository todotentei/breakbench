defmodule Breakbench.Repo.Migrations.CreateFunctionValidPeriodComparison do
  use Ecto.Migration

  def change do
    execute """
      CREATE OR REPLACE FUNCTION is_valid_period_intersect(
          valid_date0 valid_period,
          valid_date1 valid_period
        ) RETURNS BOOLEAN LANGUAGE PLPGSQL
        AS $$
        DECLARE
          min TIMESTAMP WITHOUT TIME ZONE;
          max TIMESTAMP WITHOUT TIME ZONE;
        BEGIN
          min = '0001-01-01 00:00:00';
          max = '9999-12-31 23:59:59';
          RETURN NOT (
            (COALESCE(valid_date0.valid_from, min) > COALESCE(valid_date1.valid_through, max)) OR
            (COALESCE(valid_date1.valid_from, min) > COALESCE(valid_date0.valid_through, max))
          );
        END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION is_valid_period_touch(
          valid_date0 valid_period,
          valid_date1 valid_period
        ) RETURNS BOOLEAN LANGUAGE PLPGSQL
        AS $$
        DECLARE
          min TIMESTAMP WITHOUT TIME ZONE;
          max TIMESTAMP WITHOUT TIME ZONE;
        BEGIN
          min = '0001-01-01 00:00:00';
          max = '9999-12-31 23:59:59';
          RETURN (
            (COALESCE(valid_date0.valid_from, min) = COALESCE(valid_date1.valid_through, max)) OR
            (COALESCE(valid_date1.valid_from, min) = COALESCE(valid_date0.valid_through, max))
          );
        END $$;
    """
  end

  def down do
    execute "DROP FUNCTION is_valid_period_intersect ( valid_period, valid_period )"
    execute "DROP FUNCTION is_valid_period_touch ( valid_period, valid_period )"
  end
end
