defmodule Breakbench.Repo.Migrations.CreateTriggerResolveDefaultForCurrency do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION resolve_default_for_currency()
    RETURNS TRIGGER LANGUAGE PLPGSQL
    AS $$
    DECLARE
      external_table pg_tables%rowtype;
    BEGIN
      IF NEW.account_id IS NOT NULL AND NEW.default_for_currency IS TRUE THEN
        FOR external_table IN SELECT * FROM
          pg_catalog.pg_tables
        WHERE
          schemaname = 'public' AND
          tablename in ('cards', 'bank_accounts')
        LOOP
          EXECUTE FORMAT('
            UPDATE %I AS i SET
              default_for_currency = FALSE
            WHERE
              i.id != $1 AND
              i.account_id = $2 AND
              i.currency_code = $3 AND
              i.default_for_currency = TRUE;
          ', external_table.tablename)
          USING NEW.id, NEW.account_id, NEW.currency_code;
        END LOOP;
      END IF;

      RETURN NULL;
    EXCEPTION
      WHEN feature_not_supported THEN
        RETURN NULL;
    END $$;
    """

    execute """
    CREATE TRIGGER resolve_default_for_currency
    AFTER
      INSERT OR
      UPDATE
    ON cards
      FOR EACH ROW
        EXECUTE PROCEDURE
          resolve_default_for_currency();
    """

    execute """
    CREATE TRIGGER resolve_default_for_currency
    AFTER
      INSERT OR
      UPDATE
    ON bank_accounts
      FOR EACH ROW
        EXECUTE PROCEDURE
          resolve_default_for_currency();
    """
  end

  def down do
    execute "DROP TRIGGER resolve_default_for_currency ON cards"
    execute "DROP TRIGGER resolve_default_for_currency ON bank_accounts"
    execute "DROP FUNCTION resolve_default_for_currency()"
  end
end
