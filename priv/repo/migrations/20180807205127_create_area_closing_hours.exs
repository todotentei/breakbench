defmodule Breakbench.Repo.Migrations.CreateAreaClosingHours do
  use Ecto.Migration

  def change do
    create table(:area_closing_hours, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :area_id, references(:areas, on_delete: :delete_all, type: :uuid),
        null: false
    end

    create index(:area_closing_hours, [:area_id])
  end
end
