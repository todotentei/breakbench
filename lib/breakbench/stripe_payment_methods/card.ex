defmodule Breakbench.StripePaymentMethods.Card do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "cards" do
    field :object, :string
    field :address_city, :string
    field :address_country, :string
    field :address_line1, :string
    field :address_line1_check, :string
    field :address_line2, :string
    field :address_state, :string
    field :address_zip, :string
    field :address_zip_check, :string
    field :available_payout_methods, {:array, :string}
    field :brand, :string
    field :cvc_check, :string
    field :default_for_currency, :boolean
    field :dynamic_last4, :string
    field :exp_month, :integer
    field :exp_year, :integer
    field :fingerprint, :string
    field :funding, :string
    field :last4, :string
    field :metadata, :map
    field :name, :string
    field :recipient, :string
    field :tokenization_method, :string

    belongs_to :account, Breakbench.StripeConnect.Account, type: :string,
      on_replace: :nilify
    belongs_to :country, Breakbench.AddressComponents.Country, type: :string,
      foreign_key: :country_short_name, references: :short_name, on_replace: :nilify
    belongs_to :currency, Breakbench.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :customer, Breakbench.StripeResources.Customer, type: :string,
      on_replace: :nilify
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:id, :object, :account_id, :address_city, :address_country, :address_line1,
         :address_line1_check, :address_line2, :address_state, :address_zip, :address_zip_check,
         :available_payout_methods, :brand, :country_short_name, :currency_code, :customer_id,
         :cvc_check, :default_for_currency, :dynamic_last4, :exp_month, :exp_year,
         :fingerprint, :funding, :last4, :metadata, :name, :recipient, :tokenization_method])
    |> validate_inclusion(:object, ["card"])
    |> validate_required([:id])
  end
end
