defmodule Breakbench.Repo.Migrations.CreateFields do
  use Ecto.Migration

  def change do
    create table(:fields, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :ground_id, references(:grounds, on_delete: :delete_all, type: :string),
        null: false

      timestamps()
    end

    create index(:fields, [:ground_id])
  end
end
