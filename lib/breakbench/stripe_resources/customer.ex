defmodule Breakbench.StripeResources.Customer do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "customers" do
    field :object, :string
    field :account_balance, :integer
    field :business_vat_id, :string
    field :created, :utc_datetime
    field :default_source, :string
    field :delinquent, :boolean
    field :description, :string
    field :email, :string
    field :invoice_prefix, :string
    field :metadata, :map
    field :shipping, :map

    belongs_to :currency, Breakbench.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
  end

  @doc false
  def changeset(customer, attrs) do
    customer
      |> cast(attrs, [:id, :object, :account_balance, :business_vat_id, :created,
         :default_source, :delinquent, :description, :email, :invoice_prefix, :metadata,
         :shipping])
      |> validate_inclusion(:object, ["customer"])
      |> validate_required([:id])
  end
end
