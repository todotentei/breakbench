defmodule Breakbench.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :business_logo, :string
      add :business_name, :string
      add :business_url, :string
      add :charges_enabled, :boolean
      add :country_short_name, references(:countries, column: :short_name, type: :citext, on_replace: :nilify)
      add :created, :utc_datetime
      add :debit_negative_balances, :boolean
      add :decline_charge_on, :map
      add :default_currency_code, references(:currencies, column: :code, type: :citext, on_replace: :nilify)
      add :details_submitted, :boolean
      add :display_name, :string
      add :email, :string
      add :legal_entity, :map
      add :metadata, :map
      add :payout_schedule, :map
      add :payout_statement_descriptor, :string
      add :payouts_enabled, :boolean
      add :product_description, :string
      add :statement_descriptor, :string
      add :support_email, :string
      add :support_phone, :string
      add :timezone, :string
      add :tos_acceptance, :map
      add :type, :string
      add :verification, :map
    end

    create index(:accounts, [:country_short_name])
  end
end
