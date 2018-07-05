defmodule Breakbench.Repo.Migrations.CreateSpaceOpeningHours do
  use Ecto.Migration

  def change do
    create table(:space_opening_hours, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string),
        null: false
    end

    create index(:space_opening_hours, [:space_id])
  end
end
