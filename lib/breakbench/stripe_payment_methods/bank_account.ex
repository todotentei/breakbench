defmodule Breakbench.StripePaymentMethods.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "bank_accounts" do
    field :object, :string
    field :account_holder_name, :string
    field :account_holder_type, :string
    field :bank_name, :string
    field :default_for_currency, :boolean
    field :fingerprint, :string
    field :last4, :string
    field :metadata, :map
    field :routing_number, :string
    field :status, :string

    belongs_to :account, Breakbench.StripeConnect.Account, type: :string,
      on_replace: :nilify
    belongs_to :country, Breakbench.Places.Country, type: :string,
      foreign_key: :country_short_name, references: :short_name, on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :customer, Breakbench.StripeResources.Customer, type: :string,
      on_replace: :nilify
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [:id, :object, :account_id, :account_holder_name, :account_holder_type,
         :bank_name, :country_short_name, :currency_code, :customer_id, :default_for_currency,
         :fingerprint, :last4, :metadata, :routing_number, :status])
    |> validate_inclusion(:object, ["bank_account"])
    |> validate_required([:id])
  end
end
