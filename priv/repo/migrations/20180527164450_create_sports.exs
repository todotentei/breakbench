defmodule Breakbench.Repo.Migrations.CreateSports do
  use Ecto.Migration

  def change do
    create table(:sports, primary_key: false) do
      add :name, :citext, primary_key: true
      add :type, :citext
    end

    create index(:sports, [:type])
  end
end
