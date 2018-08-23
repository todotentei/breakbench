defmodule Breakbench.Repo.Migrations.AlterMatchMembersAddStripeCharge do
  use Ecto.Migration

  def change do
    alter table(:match_members) do
      add :stripe_charge, :string
    end

    create index(:match_members, [:stripe_charge])
  end
end
