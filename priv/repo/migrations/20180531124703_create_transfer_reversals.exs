defmodule Breakbench.Repo.Migrations.CreateTransferReversals do
  use Ecto.Migration

  def change do
    create table(:transfer_reversals, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :balance_transaction_id, references(:balance_transactions, type: :string, on_replace: :nilify)
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext, on_replace: :nilify)
      add :metadata, :map
      add :transfer_id, references(:transfers, type: :string, on_replace: :nilify)
    end

    create index(:transfer_reversals, [:balance_transaction_id])
    create index(:transfer_reversals, [:currency_code])
    create index(:transfer_reversals, [:transfer_id])
  end
end
