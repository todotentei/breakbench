defmodule Breakbench.Repo.Migrations.CreateGroundClosingHours do
  use Ecto.Migration

  def change do
    create table(:ground_closing_hours, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :ground_id, references(:grounds, on_delete: :delete_all, type: :string),
        null: false
    end

    create index(:ground_closing_hours, [:ground_id])
  end
end
