defmodule Breakbench.Repo.Migrations.CreateFunctionDiff do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION diff (
        _time_range_1 time_range,
        _time_range_2 time_range
      ) RETURNS time_range [] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _time_ranges time_range [];
      BEGIN
        IF overlap(_time_range_1, _time_range_2) THEN
          IF _time_range_1.start_time < _time_range_2.start_time THEN
            _time_ranges = ARRAY_APPEND(_time_ranges, (
              _time_range_1.start_time,
              _time_range_2.start_time
            )::time_range);
          END IF;
          IF _time_range_1.end_time > _time_range_2.end_time THEN
            _time_ranges = ARRAY_APPEND(_time_ranges, (
              _time_range_2.end_time,
              _time_range_1.end_time
            )::time_range);
          END IF;
        ELSE
          _time_ranges = ARRAY_APPEND(_time_ranges, _time_range_1);
        END IF;

        RETURN _time_ranges;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION diff ( time_range, time_range )"
  end
end
