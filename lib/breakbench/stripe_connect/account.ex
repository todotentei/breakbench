defmodule Breakbench.StripeConnect.Account do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "accounts" do
    field :object, :string
    field :business_logo, :string
    field :business_name, :string
    field :business_url, :string
    field :charges_enabled, :boolean
    field :created, :utc_datetime
    field :debit_negative_balances, :boolean
    field :decline_charge_on, :map
    field :details_submitted, :boolean
    field :display_name, :string
    field :email, :string
    field :legal_entity, :map
    field :metadata, :map
    field :payout_schedule, :map
    field :payout_statement_descriptor, :string
    field :payouts_enabled, :boolean
    field :product_description, :string
    field :statement_descriptor, :string
    field :support_email, :string
    field :support_phone, :string
    field :timezone, :string
    field :tos_acceptance, :map
    field :type, :string
    field :verification, :map

    belongs_to :country, Breakbench.AddressComponents.Country, type: :string,
      foreign_key: :country_short_name, references: :short_name, on_replace: :nilify
    belongs_to :default_currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :default_currency_code, references: :code, on_replace: :nilify
  end

  @doc false
  def changeset(account, attrs) do
    account
      |> cast(attrs, [:id, :object, :business_logo, :business_name, :business_url,
         :charges_enabled, :country_short_name, :created, :debit_negative_balances,
         :decline_charge_on, :default_currency_code, :details_submitted, :display_name,
         :email, :legal_entity, :metadata, :payout_schedule, :payout_statement_descriptor,
         :payouts_enabled, :product_description, :statement_descriptor, :support_email,
         :support_phone, :timezone, :tos_acceptance, :type, :verification])
      |> validate_inclusion(:object, ["account"])
      |> validate_required([:id])
  end
end
