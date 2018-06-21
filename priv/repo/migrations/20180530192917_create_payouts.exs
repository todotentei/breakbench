defmodule Breakbench.Repo.Migrations.CreatePayouts do
  use Ecto.Migration

  def change do
    create table(:payouts, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :arrival_date, :utc_datetime
      add :automatic, :boolean
      add :balance_transaction_id, references(:balance_transactions, type: :string)
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :description, :string
      add :failure_balance_transaction, :string
      add :failure_code, :string
      add :failure_message, :string
      add :metadata, :map
      add :method, :string
      add :source_type, :string
      add :statement_descriptor, :string
      add :status, :string
      add :type, :string
    end

    create index(:payouts, [:balance_transaction_id])
    create index(:payouts, [:currency_code])
  end
end
