defmodule Breakbench.Repo.Migrations.CreateFunctionSplit do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION split (
        _time_ranges time_range [],
        _splitters time_range []
      ) RETURNS time_range [] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _time_range time_range;
        _splitter time_range;
        _return time_range [];
      BEGIN
        _return = _time_ranges;

        FOREACH _splitter IN ARRAY _splitters
        LOOP
          FOREACH _time_range IN ARRAY _time_ranges
          LOOP
            IF overlap(_time_range, _splitter) THEN
              _return = ARRAY_REMOVE(_return, _time_range);
              _return = ARRAY(SELECT DISTINCT UNNEST(
                ARRAY_CAT(_return, diff(_time_range, _splitter))
              ));

              SELECT split(_return, ARRAY_REMOVE(_splitters, _splitter))
              INTO _return;
            END IF;
          END LOOP;
        END LOOP;

        RETURN _return;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION split ( time_range[], time_range[] )"
  end
end
