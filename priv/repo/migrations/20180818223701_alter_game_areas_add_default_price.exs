defmodule Breakbench.Repo.Migrations.AlterGameAreasAddDefaultPrice do
  use Ecto.Migration

  def change do
    alter table(:game_areas) do
      add :default_price, :integer, null: false
    end
  end
end
