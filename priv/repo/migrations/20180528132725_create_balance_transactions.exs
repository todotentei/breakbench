defmodule Breakbench.Repo.Migrations.CreateBalanceTransactions do
  use Ecto.Migration

  def change do
    create table(:balance_transactions, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :available_on, :utc_datetime
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :description, :string
      add :exchange_rate, :decimal
      add :fee, :integer
      add :fee_details, {:array, :map}
      add :net, :integer
      add :status, :string
      add :type, :string
    end

    create index(:balance_transactions, [:currency_code])
  end
end
