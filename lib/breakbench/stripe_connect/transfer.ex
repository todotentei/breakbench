defmodule Breakbench.StripeConnect.Transfer do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "transfers" do
    field :object, :string
    field :amount, :integer
    field :amount_reversed, :integer
    field :created, :utc_datetime
    field :description, :string
    field :destination_payment, :string
    field :metadata, :map
    field :reversed, :boolean
    field :source_type, :string
    field :transfer_group, :string

    belongs_to :balance_transaction, Breakbench.StripeResources.BalanceTransaction,
      type: :string, on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :destination, Breakbench.StripeConnect.Account, type: :string,
      on_replace: :nilify
    belongs_to :source_transaction, Breakbench.StripeResources.Charge,
      type: :string, on_replace: :nilify
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
      |> cast(attrs, [:id, :object, :amount, :amount_reversed, :balance_transaction_id,
           :created, :currency_code, :description, :destination_id, :destination_payment,
           :metadata, :reversed, :source_transaction_id, :source_type, :transfer_group])
      |> validate_inclusion(:object, ["transfer"])
      |> validate_required([:id])
  end
end
