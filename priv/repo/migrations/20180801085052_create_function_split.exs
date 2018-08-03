defmodule Breakbench.Repo.Migrations.CreateFunctionSplit do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION split (
        _time_ranges_1 int4range[],
        _time_ranges_2 int4range[]
      ) RETURNS int4range[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _tr int4range;
        _st int4range;
        _rt int4range[];
      BEGIN
        _rt = _time_ranges_1;

        FOREACH _st IN ARRAY _time_ranges_2
        LOOP
          FOREACH _tr IN ARRAY _time_ranges_1
          LOOP
            IF _tr && _st THEN
              _rt = ARRAY_REMOVE(_rt, _tr);
              _rt = ARRAY(SELECT DISTINCT UNNEST(
                ARRAY_CAT(_rt, diff(_tr, _st))
              ));

              SELECT split(_rt, ARRAY_REMOVE(_time_ranges_2, _st))
              INTO _rt;
            END IF;
          END LOOP;
        END LOOP;

        RETURN _rt;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION split ( int4range[], int4range[] )"
  end
end
