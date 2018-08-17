defmodule Breakbench.Repo.Migrations.AlterGameAreaRemoveSpaceAddArea do
  use Ecto.Migration

  def change do
    alter table(:game_areas) do
      remove :space_id
      add :area_id, references(:areas, on_delete: :delete_all, type: :uuid)
    end
  end
end
