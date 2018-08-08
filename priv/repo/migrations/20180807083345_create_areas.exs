defmodule Breakbench.Repo.Migrations.CreateAreas do
  use Ecto.Migration

  def change do
    create table(:areas, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string)
    end
  end
end
