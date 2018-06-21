defmodule Breakbench.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :middle_name, :string
      add :last_name, :string, null: false
      add :given_name, :string
      add :email, :string, null: false
      add :date_of_birth, :date
      add :gender, :string
      add :username, :string, null: false
      add :profile, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
