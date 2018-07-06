defmodule Breakbench.Repo.Migrations.CreateGrounds do
  use Ecto.Migration

  def change do
    create table(:grounds, primary_key: false) do
      add :id, :string, primary_key: true
      add :description, :string
      add :default_price, :integer
      add :space_id, references(:spaces, on_delete: :delete_all, type: :string)

      timestamps()
    end
  end
end
