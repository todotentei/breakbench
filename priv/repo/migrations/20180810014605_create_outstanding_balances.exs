defmodule Breakbench.Repo.Migrations.CreateOutstandingBalances do
  use Ecto.Migration

  def change do
    create table(:outstanding_balances) do
      add :amount, :integer, null: false
      add :reason, :string

      add :user_id, references(:users, on_delete: :nothing),
        null: false
      add :currency_code, references(:currencies, column: :code, type: :citext),
        null: false
    end

    create index(:outstanding_balances, [:user_id])
    create index(:outstanding_balances, [:currency_code])
  end
end
