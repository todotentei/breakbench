defmodule Breakbench.Repo.Migrations.CreateFunctionAffectedFields do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION affected_fields (
        _field_id CHARACTER VARYING(255)
      ) RETURNS TABLE (
        field_id CHARACTER VARYING(255)
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY

        SELECT aff.field_id
        FROM affected_fields AS aff
        WHERE aff.affected_id = _field_id

        UNION

        SELECT aff.affected_id
        FROM affected_fields AS aff
        WHERE aff.field_id = _field_id;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION affected_fields ( CHARACTER VARYING )"
  end
end
