defmodule Breakbench.Repo.Migrations.CreateFunctionSearchrange do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION searchrange (
        _start TIMESTAMP WITHOUT TIME ZONE,
        _duration INTERVAL,
        _delay INTERVAL DEFAULT '15 MIN'::INTERVAL,
        _margin INTERVAL DEFAULT '45 MIN'::INTERVAL,
        _ceil INTERVAL DEFAULT '5 MIN'::INTERVAL
      ) RETURNS tsrange LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _kickoff TIMESTAMP;
      BEGIN
        _kickoff = tsceil((_start + _delay), _ceil);
        RETURN tsrange(_kickoff, (_kickoff + _duration + _margin));
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION searchrange ( TIMESTAMP WITHOUT TIME ZONE, INTERVAL, INTERVAL, INTERVAL, INTERVAL )"
  end
end
