defmodule Breakbench.Repo.Migrations.AlterFieldDynamicPricingsReplaceFieldWithFieldGameMode do
  use Ecto.Migration

  def change do
    alter table(:field_dynamic_pricings) do
      remove :field_id

      add :field_game_mode_id, references(:field_game_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:field_dynamic_pricings, [:field_game_mode_id])
  end
end
