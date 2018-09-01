defmodule Breakbench.Repo.Migrations.AlterUsersAddSessions do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sessions, {:map, :integer}, default: "{}"
    end
  end
end
