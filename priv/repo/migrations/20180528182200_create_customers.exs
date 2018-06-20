defmodule Breakbench.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :account_balance, :integer
      add :business_vat_id, :string
      add :created, :utc_datetime
      add :default_source, :string
      add :currency_code, references(:currencies, column: :code, type: :citext, on_replace: :nilify)
      add :delinquent, :boolean
      add :description, :string
      add :email, :string
      add :invoice_prefix, :string
      add :metadata, :map
      add :shipping, :map
    end

    create index(:customers, [:currency_code])
  end
end
