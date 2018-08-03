defmodule Breakbench.Repo.Migrations.CreateFunctionDiff do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION diff (
        _time_range_1 int4range,
        _time_range_2 int4range
      ) RETURNS int4range[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _time_ranges int4range[];
      BEGIN
        IF _time_range_1 && _time_range_2 THEN
          IF lower(_time_range_1) < lower(_time_range_2) THEN
            _time_ranges = ARRAY_APPEND(_time_ranges,
              int4range(lower(_time_range_1), lower(_time_range_2), '[)'));
          END IF;
          IF upper(_time_range_1) > upper(_time_range_2) THEN
            _time_ranges = ARRAY_APPEND(_time_ranges,
              int4range(upper(_time_range_2), upper(_time_range_1), '[)'));
          END IF;
        ELSE
          _time_ranges = ARRAY_APPEND(_time_ranges, _time_range_1);
        END IF;

        RETURN _time_ranges;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION diff ( int4range, int4range )"
  end
end
