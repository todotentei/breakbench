defmodule Breakbench.Repo.Migrations.CreateFunctionOverlapTimeBlocks do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION overlap_time_blocks (
        _day_of_week INTEGER,
        _start_time INTEGER,
        _end_time INTEGER,
        _from_date DATE,
        _through_date DATE
      ) RETURNS TABLE (id UUID) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          tbk.id
        FROM time_blocks AS tbk
        WHERE
          tbk.day_of_week = _day_of_week AND
          int4range(tbk.start_time, tbk.end_time, '[]')
            && int4range(_start_time, _end_time, '[]') AND
          daterange(tbk.from_date, tbk.through_date, '[]')
            && daterange(_from_date, _through_date, '[]');
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION overlap_time_blocks ( INTEGER, INTEGER, INTEGER, DATE, DATE )"
  end
end
