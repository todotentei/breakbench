defmodule Breakbench.Repo.Migrations.CreateTriggerInAreaAffectedGameArea do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION in_area_affected_game_area()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      BEGIN
        IF NOT EXISTS (
          SELECT TRUE
          FROM game_areas AS gar
          RIGHT OUTER JOIN game_areas AS aff ON
            aff.id = NEW.affected_id AND
            aff.area_id = gar.area_id
          WHERE
            gar.id = NEW.game_area_id
        ) THEN
          RAISE EXCEPTION 'error set affected game area outside area';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER in_area_affected_game_area
      BEFORE INSERT
      ON affected_game_areas
        FOR EACH ROW
          EXECUTE PROCEDURE
            in_area_affected_game_area();
    """
  end

  def down do
    execute "DROP TRIGGER in_area_affected_game_area ON affected_game_areas"
    execute "DROP FUNCTION in_area_affected_game_area ( )"
  end
end
