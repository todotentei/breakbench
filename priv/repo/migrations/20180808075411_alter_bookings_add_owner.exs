defmodule Breakbench.Repo.Migrations.AlterBookingsAddOwner do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :match_id, references(:matches, on_delete: :delete_all, type: :uuid)
    end

    create index(:bookings, [:user_id])
    create index(:bookings, [:match_id])

    create constraint(:bookings, "one_owner_is_present",
      check: "(user_id IS NULL) != (match_id IS NULL)")
  end
end
