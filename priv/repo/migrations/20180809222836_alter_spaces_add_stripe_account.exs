defmodule Breakbench.Repo.Migrations.AlterSpacesAddStripeAccount do
  use Ecto.Migration

  def change do
    alter table(:spaces) do
      add :stripe_account, :string
    end

    create unique_index(:spaces, [:stripe_account])
  end
end
