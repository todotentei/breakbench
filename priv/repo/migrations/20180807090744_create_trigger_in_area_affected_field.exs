defmodule Breakbench.Repo.Migrations.CreateTriggerInAreaAffectedField do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION in_area_affected_field()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      BEGIN
        IF NOT EXISTS (
          SELECT TRUE
          FROM fields AS fld
          RIGHT OUTER JOIN fields AS aff ON
            aff.id = NEW.affected_id AND
            aff.area_id = fld.area_id
          WHERE
            fld.id = NEW.field_id
        ) THEN
          RAISE EXCEPTION 'error set affected field outside area';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER in_area_affected_field
      BEFORE INSERT
      ON affected_fields
        FOR EACH ROW
          EXECUTE PROCEDURE
            in_area_affected_field();
    """
  end

  def down do
    execute "DROP TRIGGER in_area_affected_field ON affected_fields"
    execute "DROP FUNCTION in_area_affected_field ( )"
  end
end
