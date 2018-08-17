defmodule Breakbench.Repo.Migrations.CreateGameAreaDynamicPricings do
  use Ecto.Migration

  def change do
    create table(:game_area_dynamic_pricings, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :game_area_id, references(:game_areas, on_delete: :delete_all, type: :string),
        null: false
      add :price, :integer, null: false
    end

    create index(:game_area_dynamic_pricings, [:game_area_id])
  end
end
