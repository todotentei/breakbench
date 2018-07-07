defmodule Breakbench.Repo.Migrations.CreateFieldClosingHours do
  use Ecto.Migration

  def change do
    create table(:field_closing_hours, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :field_id, references(:fields, on_delete: :delete_all, type: :string),
        null: false
    end

    create index(:field_closing_hours, [:field_id])
  end
end
