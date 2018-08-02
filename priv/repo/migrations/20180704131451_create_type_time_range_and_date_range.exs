defmodule Breakbench.Repo.Migrations.CreateTypeTimeRangeAndDateRange do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE time_range AS (
        start_time TIME WITHOUT TIME ZONE,
        end_time TIME WITHOUT TIME ZONE
      )
    """

    execute """
      CREATE TYPE date_range AS (
        from_date DATE,
        through_date DATE
      )
    """
  end

  def down do
    execute "DROP TYPE time_range"
    execute "DROP TYPE date_range"
  end
end
