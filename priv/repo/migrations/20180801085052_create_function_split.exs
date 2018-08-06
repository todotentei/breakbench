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

        FOREACH _st IN ARRAY _time_ranges_2 LOOP
          FOREACH _tr IN ARRAY _time_ranges_1 LOOP
            IF _tr && _st THEN
              _rt = ARRAY_REMOVE(_rt, _tr);
              _rt = ARRAY(SELECT DISTINCT UNNEST(
                ARRAY_CAT(_rt, diff(_tr, _st))
              ));

              _rt = split(_rt, ARRAY_REMOVE(_time_ranges_2, _st));
            END IF;
          END LOOP;
        END LOOP;

        RETURN _rt;
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION split (
        _tsrange_1 tsrange[],
        _tsrange_2 tsrange[]
      ) RETURNS tsrange[] LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _ts1 tsrange; _ts2 tsrange;
        _rtn tsrange[];
      BEGIN
        _rtn = _tsrange_1;

        FOREACH _ts2 IN ARRAY _tsrange_2 LOOP
          FOREACH _ts1 IN ARRAY _tsrange_1 LOOP
            IF _ts1 && _ts2 THEN
              _rtn = ARRAY_REMOVE(_rtn, _ts1);
              _rtn = ARRAY(SELECT DISTINCT UNNEST(
                ARRAY_CAT(_rtn, diff(_ts1, _ts2))
              ));

              _rtn = split(_rtn, ARRAY_REMOVE(_tsrange_2, _ts2));
            END IF;
          END LOOP;
        END LOOP;

        RETURN _rtn;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION split ( int4range[], int4range[] )"
    execute "DROP FUNCTION split ( tsrange[], tsrange[] )"
  end
end
