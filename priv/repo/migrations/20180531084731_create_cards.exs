defmodule Breakbench.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :account_id, references(:accounts, type: :string)
      add :address_city, :string
      add :address_country, :string
      add :address_line1, :string
      add :address_line1_check, :string
      add :address_line2, :string
      add :address_state, :string
      add :address_zip, :string
      add :address_zip_check, :string
      add :available_payout_methods, {:array, :string}
      add :brand, :string
      add :country_short_name, references(:countries, column: :short_name, type: :citext, on_replace: :nilify)
      add :currency_code, references(:currencies, column: :code, type: :citext, on_replace: :nilify)
      add :customer_id, references(:customers, type: :string, on_replace: :nilify)
      add :cvc_check, :string
      add :default_for_currency, :boolean
      add :dynamic_last4, :string
      add :exp_month, :integer
      add :exp_year, :integer
      add :fingerprint, :string
      add :funding, :string
      add :last4, :string
      add :metadata, :map
      add :name, :string
      add :recipient, :string
      add :tokenization_method, :string
    end

    create index(:cards, [:account_id])
    create index(:cards, [:country_short_name])
    create index(:cards, [:currency_code])
    create index(:cards, [:customer_id])
  end
end
