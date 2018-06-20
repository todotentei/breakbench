defmodule Breakbench.StripeResources.Refund do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "refunds" do
    field :object, :string
    field :amount, :integer
    field :created, :utc_datetime
    field :failure_balance_transaction, :string
    field :failure_reason, :string
    field :metadata, :map
    field :reason, :string
    field :receipt_number, :string
    field :status, :string

    belongs_to :balance_transaction, Breakbench.StripeResources.BalanceTransaction,
      type: :string, on_replace: :nilify
    belongs_to :charge, Breakbench.StripeResources.Charge, type: :string,
      on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
  end

  @doc false
  def changeset(refund, attrs) do
    refund
      |> cast(attrs, [:id, :object, :amount, :balance_transaction_id, :charge_id,
           :created, :currency_code, :failure_balance_transaction, :failure_reason,
           :metadata, :reason, :receipt_number, :status])
      |> validate_inclusion(:object, ["refund"])
      |> validate_required([:id])
  end
end
