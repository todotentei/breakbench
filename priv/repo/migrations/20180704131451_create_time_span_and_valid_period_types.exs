defmodule Breakbench.Repo.Migrations.CreateTimeSpanAndValidPeriodTypes do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE time_span AS (start_at TIME WITHOUT TIME ZONE,
        end_at TIME WITHOUT TIME ZONE)
    """

    execute """
      CREATE TYPE valid_period AS (valid_from TIMESTAMP WITHOUT TIME ZONE,
        valid_through TIMESTAMP WITHOUT TIME ZONE)
    """
  end

  def down do
    execute "DROP TYPE time_span"
    execute "DROP TYPE valid_period"
  end
end
