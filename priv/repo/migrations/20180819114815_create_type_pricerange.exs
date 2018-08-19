defmodule Breakbench.Repo.Migrations.CreateTypePricerange do
  use Ecto.Migration

  def up do
    execute """
      CREATE TYPE pricerange AS (
        date DATE,
        timerange int4range,
        price integer
      )
    """
  end

  def down do
    execute "DROP TYPE pricerange"
  end
end
