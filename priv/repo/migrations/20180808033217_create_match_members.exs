defmodule Breakbench.Repo.Migrations.CreateMatchMembers do
  use Ecto.Migration

  def change do
    create table(:match_members, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :match_id, references(:matches, on_delete: :delete_all, type: :uuid),
        null: false
      add :user_id, references(:users, on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(:match_members, [:match_id])
    create index(:match_members, [:user_id])
    create unique_index(:match_members, [:match_id, :user_id])
  end
end
