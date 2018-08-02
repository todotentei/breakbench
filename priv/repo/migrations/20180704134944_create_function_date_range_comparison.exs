defmodule Breakbench.Repo.Migrations.CreateFunctionDateRangeComparison do
  use Ecto.Migration

  def change do
    execute """
      CREATE OR REPLACE FUNCTION overlap (
          date_range0 date_range,
          date_range1 date_range
        ) RETURNS BOOLEAN LANGUAGE PLPGSQL
        AS $$
        DECLARE
          min DATE;
          max DATE;
        BEGIN
          min = '0001-01-01';
          max = '9999-12-31';
          RETURN NOT (
            (COALESCE(date_range0.from_date, min) > COALESCE(date_range1.through_date, max)) OR
            (COALESCE(date_range1.from_date, min) > COALESCE(date_range0.through_date, max))
          );
        END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION touch (
          date_range0 date_range,
          date_range1 date_range
        ) RETURNS BOOLEAN LANGUAGE PLPGSQL
        AS $$
        DECLARE
          min DATE;
          max DATE;
        BEGIN
          min = '0001-01-01';
          max = '9999-12-31';
          RETURN (
            (COALESCE(date_range0.from_date, min) = COALESCE(date_range1.through_date, max)) OR
            (COALESCE(date_range1.from_date, min) = COALESCE(date_range0.through_date, max))
          );
        END $$;
    """
  end

  def down do
    execute "DROP FUNCTION overlap ( date_range, date_range )"
    execute "DROP FUNCTION touch ( date_range, date_range )"
  end
end
