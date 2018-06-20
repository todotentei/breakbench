defmodule Breakbench.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :amount_reversed, :integer
      add :balance_transaction_id, references(:balance_transactions, type: :string, on_replace: :nilify)
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext, on_replace: :nilify)
      add :description, :string
      add :destination_id, references(:accounts, type: :string, on_replace: :nilify)
      add :destination_payment, :string
      add :metadata, :map
      add :reversed, :boolean
      add :source_transaction_id, references(:charges, type: :string, on_replace: :nilify)
      add :source_type, :string
      add :transfer_group, :string
    end

    create index(:transfers, [:balance_transaction_id])
    create index(:transfers, [:currency_code])
    create index(:transfers, [:destination_id])
    create index(:transfers, [:source_transaction_id])
  end
end
