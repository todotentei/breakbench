defmodule Breakbench.Repo.Migrations.CreateFieldDynamicPricings do
  use Ecto.Migration

  def change do
    create table(:field_dynamic_pricings, primary_key: false) do
      add :time_block_id, references(:time_blocks, on_delete: :delete_all, type: :uuid),
        primary_key: true, null: false
      add :field_id, references(:fields, on_delete: :delete_all, type: :string),
        null: false
      add :price, :integer, null: false
    end

    create index(:field_dynamic_pricings, [:field_id])
  end
end
