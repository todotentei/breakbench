defmodule Breakbench.Repo.Migrations.CreateFunctionTsceil do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION tsceil (
        _timestamp TIMESTAMP WITHOUT TIME ZONE,
        _multiple INTERVAL
      ) RETURNS TIMESTAMP WITHOUT TIME ZONE LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _nearest INTEGER;
      BEGIN
        _nearest = EXTRACT(EPOCH FROM _multiple);

        RETURN TO_TIMESTAMP(CEIL(
          EXTRACT(EPOCH FROM _timestamp) / _nearest
        ) * _nearest) AT TIME ZONE 'UTC';
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION tsceil ( TIMESTAMP WITHOUT TIME ZONE, INTERVAL )"
  end
end
