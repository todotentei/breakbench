defmodule Breakbench.Repo.Migrations.AlterMatchesAddStripeTransferGroup do
  use Ecto.Migration

  def change do
    alter table(:matches) do
      add :stripe_transfer_group, :string
    end

    create unique_index(:matches, [:stripe_transfer_group])
  end
end
