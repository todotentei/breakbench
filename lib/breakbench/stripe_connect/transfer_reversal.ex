defmodule Breakbench.StripeConnect.TransferReversal do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "transfer_reversals" do
    field :object, :string
    field :amount, :integer
    field :created, :utc_datetime
    field :metadata, :map

    belongs_to :balance_transaction, Breakbench.StripeResources.BalanceTransaction,
      type: :string, on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :transfer, Breakbench.StripeConnect.Transfer, type: :string,
      on_replace: :nilify
  end

  @doc false
  def changeset(transfer_reversal, attrs) do
    transfer_reversal
    |> cast(attrs, [:id, :object, :amount, :balance_transaction_id, :created,
         :currency_code, :metadata, :transfer_id])
    |> validate_inclusion(:object, ["transfer_reversal"])
    |> validate_required([:id])
  end
end
