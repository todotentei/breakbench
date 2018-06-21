defmodule Breakbench.Repo.Migrations.CreateRefunds do
  use Ecto.Migration

  def change do
    create table(:refunds, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :balance_transaction_id, references(:balance_transactions, type: :string)
      add :charge_id, references(:charges, type: :string)
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :failure_balance_transaction, :string
      add :failure_reason, :string
      add :metadata, :map
      add :reason, :string
      add :receipt_number, :string
      add :status, :string
    end

    create index(:refunds, [:balance_transaction_id])
    create index(:refunds, [:charge_id])
    create index(:refunds, [:currency_code])
  end
end
