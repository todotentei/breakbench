defmodule Breakbench.Repo.Migrations.CreateOutstandingBalances do
  use Ecto.Migration

  def change do
    create table(:outstanding_balances, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing),
        null: false, primary_key: true
      add :currency_code, references(:currencies, column: :code, type: :citext),
        null: false, primary_key: true
      add :amount, :integer, null: false
    end
  end
end
