defmodule Breakbench.Repo.Migrations.CreateFunctionAffectedGameAreas do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION affected_game_areas (
        _game_area_id CHARACTER VARYING(255)
      ) RETURNS TABLE (
        game_area_id CHARACTER VARYING(255)
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY

        SELECT aff.game_area_id
        FROM affected_game_areas AS aff
        WHERE aff.affected_id = _game_area_id

        UNION

        SELECT aff.affected_id
        FROM affected_game_areas AS aff
        WHERE aff.game_area_id = _game_area_id;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION affected_game_areas ( CHARACTER VARYING )"
  end
end
