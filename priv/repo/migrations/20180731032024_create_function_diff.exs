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

    execute """
      CREATE OR REPLACE FUNCTION diff (
        _tsrange_1 tsrange,
        _tsrange_2 tsrange
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tsranges tsrange[];
      BEGIN
        IF _tsrange_1 && _tsrange_2 THEN
          IF lower(_tsrange_1) < lower(_tsrange_2) THEN
            _tsranges = ARRAY_APPEND(_tsranges,
              tsrange(lower(_tsrange_1), lower(_tsrange_2), '[)'));
          END IF;
          IF upper(_tsrange_1) > upper(_tsrange_2) THEN
            _tsranges = ARRAY_APPEND(_tsranges,
              tsrange(upper(_tsrange_2), upper(_tsrange_1), '[)'));
          END IF;
        ELSE
          _tsranges = ARRAY_APPEND(_tsranges, _tsrange_1);
        END IF;

        RETURN _tsranges;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION diff ( int4range, int4range )"
    execute "DROP FUNCTION diff ( tsrange, tsrange )"
  end
end
