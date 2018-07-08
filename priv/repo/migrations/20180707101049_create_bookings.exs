defmodule Breakbench.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :kickoff, :naive_datetime, null: false
      add :duration, :integer, null: false
      add :field_id, references(:fields, on_delete: :nothing, type: :string),
        null: false

      timestamps()
    end

    create index(:bookings, [:field_id])
  end
end
