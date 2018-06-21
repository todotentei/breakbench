defmodule Breakbench.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :amount_refunded, :integer
      add :application, :string
      add :application_fee, :string
      add :balance_transaction_id, references(:balance_transactions, type: :string)
      add :captured, :boolean
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :customer_id, references(:customers, type: :string)
      add :description, :string
      add :destination_id, references(:accounts, type: :string)
      add :dispute, :string
      add :failure_code, :string
      add :failure_message, :string
      add :fraud_details, :map
      add :invoice, :string
      add :metadata, :map
      add :on_behalf_of_id, references(:accounts, type: :string)
      add :outcome, :map
      add :paid, :boolean
      add :receipt_email, :string
      add :receipt_number, :string
      add :refunded, :boolean
      add :shipping, :map
      add :source, :map
      add :statement_descriptor, :string
      add :status, :string
    end

    create index(:charges, [:balance_transaction_id])
    create index(:charges, [:currency_code])
    create index(:charges, [:destination_id])
    create index(:charges, [:on_behalf_of_id])
  end
end
