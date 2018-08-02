defmodule Breakbench.Repo.Migrations.CreateTriggerOverlapFieldDynamicPricing do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_field_dynamic_pricing()
      RETURNS TRIGGER LANGUAGE PLPGSQL
      AS $$
      DECLARE
        new_time_block time_blocks;
        new_time_range time_range;
        new_date_range date_range;
        overlapped BOOLEAN;
      BEGIN
        SELECT * FROM time_blocks AS tbk
        INTO new_time_block
        WHERE tbk.id = NEW.time_block_id;

        new_time_range = (new_time_block.start_time, new_time_block.end_time)::time_range;
        new_date_range = (new_time_block.from_date, new_time_block.through_date)::date_range;

        SELECT EXISTS (
          SELECT * FROM field_dynamic_pricings AS fdp
          JOIN time_blocks AS tbk ON tbk.id = fdp.time_block_id
          WHERE
            fdp.field_id = NEW.field_id AND
            fdp.price = NEW.price AND
            tbk.day_of_week = new_time_block.day_of_week AND
            overlap(
              (tbk.start_time, tbk.end_time)::time_range,
              new_time_range
            ) AND
            not(touch (
              (tbk.start_time, tbk.end_time)::time_range,
              new_time_range
            )) AND
            overlap(
              (tbk.from_date, tbk.through_date)::date_range,
              new_date_range
            ) AND
            not(touch (
              (tbk.from_date, tbk.through_date)::date_range,
              new_date_range
            ))
        ) INTO overlapped;

        IF overlapped THEN
          RAISE EXCEPTION 'error overlap field dynamic pricing';
        END IF;

        RETURN NEW;
      END $$;
    """

    execute """
      CREATE TRIGGER overlap_field_dynamic_pricing
      BEFORE
        INSERT OR
        UPDATE
      ON field_dynamic_pricings
        FOR EACH ROW
          EXECUTE PROCEDURE
            overlap_field_dynamic_pricing();
    """
  end

  def down do
    execute "DROP TRIGGER overlap_field_dynamic_pricing ON field_dynamic_pricings"
    execute "DROP FUNCTION overlap_field_dynamic_pricing ( )"
  end
end
