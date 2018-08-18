defmodule Breakbench.Repo.Migrations.CreateAffectedGameAreas do
  use Ecto.Migration

  def change do
    create table(:affected_game_areas, primary_key: false) do
      add :game_area_id, references(:game_areas, on_delete: :delete_all, type: :uuid),
        primary_key: true
      add :affected_id, references(:game_areas, on_delete: :delete_all, type: :uuid),
        primary_key: true
    end

    create constraint(:affected_game_areas, "ban_self_referencing", check: "game_area_id <> affected_id")
    create constraint(:affected_game_areas, "directionless", check: "game_area_id < affected_id")
  end
end
