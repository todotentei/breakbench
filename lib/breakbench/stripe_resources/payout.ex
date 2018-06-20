defmodule Breakbench.StripeResources.Payout do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "payouts" do
    field :object, :string
    field :amount, :integer
    field :arrival_date, :utc_datetime
    field :automatic, :boolean
    field :created, :utc_datetime
    field :description, :string
    field :failure_balance_transaction, :string
    field :failure_code, :string
    field :failure_message, :string
    field :metadata, :map
    field :method, :string
    field :source_type, :string
    field :statement_descriptor, :string
    field :status, :string
    field :type, :string

    belongs_to :balance_transaction, Breakbench.StripeResources.BalanceTransaction,
      type: :string, on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
  end

  @doc false
  def changeset(payout, attrs) do
    payout
    |> cast(attrs, [:id, :amount, :arrival_date, :automatic, :balance_transaction_id,
         :created, :currency_code, :description, :failure_balance_transaction,
         :failure_code, :failure_message, :metadata, :method, :source_type, :statement_descriptor,
         :status, :type])
    |> validate_inclusion(:object, ["payout"])
    |> validate_required([:id])
  end
end
