defmodule Breakbench.Repo.Migrations.AlterUsersAddStripeCustomer do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_customer, :string
    end

    create unique_index(:users, [:stripe_customer])
  end
end
