defmodule Breakbench.Repo.Migrations.CreateFields do
  use Ecto.Migration

  def change do
    create table(:fields, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string)

      timestamps()
    end

    create index(:fields, [:space_id])
  end
end
