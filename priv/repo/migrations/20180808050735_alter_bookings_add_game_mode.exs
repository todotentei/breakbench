defmodule Breakbench.Repo.Migrations.AlterBookingsAddGameMode do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :game_mode_id, references(:game_modes, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:bookings, [:game_mode_id])
  end
end
