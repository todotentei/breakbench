defmodule Breakbench.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :full_name, :string, null: false
      add :given_name, :string
      add :email, :citext, null: false
      add :date_of_birth, :date
      add :gender, :citext
      add :username, :citext, null: false
      add :profile, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
