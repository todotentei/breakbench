defmodule Breakbench.Repo.Migrations.AlterBookingsAddPriceAndCurrency do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :price, :integer,
        null: false
      add :currency_code, references(:currencies, column: :code, type: :citext),
        null: false
    end

    create index(:bookings, [:currency_code])
  end
end
