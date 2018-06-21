defmodule Breakbench.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :account_id, references(:accounts, type: :string)
      add :account_holder_name, :string
      add :account_holder_type, :string
      add :bank_name, :string
      add :country_short_name, references(:countries, column: :short_name, type: :citext)
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :customer_id, references(:customers, type: :string)
      add :default_for_currency, :boolean
      add :fingerprint, :string
      add :last4, :string
      add :metadata, :map
      add :routing_number, :string
      add :status, :string
    end

    create index(:bank_accounts, [:account_id])
    create index(:bank_accounts, [:country_short_name])
    create index(:bank_accounts, [:currency_code])
    create index(:bank_accounts, [:customer_id])
  end
end
