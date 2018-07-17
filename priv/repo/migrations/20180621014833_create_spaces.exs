defmodule Breakbench.Repo.Migrations.CreateSpaces do
  use Ecto.Migration

  def change do
    create table(:spaces, primary_key: false) do
      add :id, :string, primary_key: true
      add :owner_id, references(:users, on_delete: :delete_all)
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :phone, :string
      add :email, :string
      add :website, :string
      add :about, :string
      add :address, :string
      add :latitude, :float
      add :longitude, :float
      add :timezone, :string

      timestamps()
    end

    create index(:spaces, [:currency_code])
    create index(:spaces, [:owner_id])
  end
end
