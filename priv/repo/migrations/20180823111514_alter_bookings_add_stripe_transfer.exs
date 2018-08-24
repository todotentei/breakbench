defmodule Breakbench.Repo.Migrations.AlterBookingsAddStripeTransfer do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :stripe_transfer, :string
    end

    create index(:bookings, [:stripe_transfer])
  end
end
