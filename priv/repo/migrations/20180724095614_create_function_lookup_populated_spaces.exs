defmodule Breakbench.Repo.Migrations.CreateFunctionLookupPopulatedSpaces do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION lookup_populated_spaces (
        _geom geometry(Point,4326),
        _radius INTEGER
      ) RETURNS VOID LANGUAGE PLPGSQL
      AS $$
      DECLARE
        populated_spaces JSON;
      BEGIN
        WITH ps AS (
          SELECT space_id, game_mode_id
          FROM populated_spaces(_geom, _radius)
        )
        SELECT TO_JSON(ARRAY_AGG(ps)) FROM ps
        INTO populated_spaces;

        IF populated_spaces IS NOT NULL THEN
          PERFORM pg_notify('populated_spaces', populated_spaces::TEXT);
        END IF;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION lookup_populated_spaces ( geometry, integer )"
  end
end
