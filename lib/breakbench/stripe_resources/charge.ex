defmodule Breakbench.StripeResources.Charge do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "charges" do
    field :object, :string
    field :amount, :integer
    field :amount_refunded, :integer
    field :application, :string
    field :application_fee, :string
    field :captured, :boolean
    field :created, :utc_datetime
    field :description, :string
    field :dispute, :string
    field :failure_code, :string
    field :failure_message, :string
    field :fraud_details, :map
    field :invoice, :string
    field :metadata, :map
    field :outcome, :map
    field :paid, :boolean
    field :receipt_email, :string
    field :receipt_number, :string
    field :refunded, :boolean
    field :shipping, :map
    field :source, :map
    field :statement_descriptor, :string
    field :status, :string
    field :transfer_group, :string

    belongs_to :balance_transaction, Breakbench.StripeResources.BalanceTransaction,
      type: :string, on_replace: :nilify
    belongs_to :currency, Breakbench.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :customer, Breakbench.StripeResources.Customer, type: :string,
      on_replace: :nilify
    belongs_to :destination, Breakbench.StripeConnect.Account, type: :string,
      on_replace: :nilify
    belongs_to :on_behalf_of, Breakbench.StripeConnect.Account, type: :string,
      on_replace: :nilify
    belongs_to :source_transfer, Breakbench.StripeConnect.Transfer, type: :string,
      on_replace: :nilify
    belongs_to :transfer, Breakbench.StripeConnect.Transfer, type: :string,
      on_replace: :nilify
  end

  @doc false
  def changeset(charge, attrs) do
    charge
      |> cast(attrs, [:id, :object, :amount, :amount_refunded, :application, :application_fee,
           :balance_transaction_id, :captured, :created, :currency_code, :description,
           :destination_id, :dispute, :failure_code, :failure_message, :fraud_details,
           :invoice, :metadata, :on_behalf_of_id, :outcome, :paid, :receipt_email,
           :receipt_number, :refunded, :shipping, :source, :source_transfer_id,
           :statement_descriptor, :status, :transfer_id, :transfer_group])
      |> validate_inclusion(:object, ["charge"])
      |> validate_required([:id])
  end
end
