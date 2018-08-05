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
    execute "CREATE INDEX bookings_tsrange_until_index ON bookings USING gist (tsrange(kickoff,kickoff + duration * INTERVAL '1 SEC','[)'))",
      "DROP INDEX bookings_tsrange_until_index"
  end
end
