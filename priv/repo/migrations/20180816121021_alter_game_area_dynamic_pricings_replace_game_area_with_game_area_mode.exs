defmodule Breakbench.Repo.Migrations.AlterGameAreaDynamicPricingsReplaceGameAreaWithGameAreaMode do
  use Ecto.Migration

  def change do
    alter table(:game_area_dynamic_pricings) do
      remove :game_area_id

      add :game_area_mode_id, references(:game_area_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:game_area_dynamic_pricings, [:game_area_mode_id])
  end
end
