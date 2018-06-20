defmodule Breakbench.StripeResources.BalanceTransaction do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "balance_transactions" do
    field :object, :string
    field :amount, :integer
    field :available_on, :utc_datetime
    field :created, :utc_datetime
    field :description, :string
    field :exchange_rate, :decimal
    field :fee, :integer
    field :fee_details, {:array, :map}
    field :net, :integer
    field :status, :string
    field :type, :string

    belongs_to :currency, Breakbench.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
  end

  @doc false
  def changeset(balance_transaction, attrs) do
    balance_transaction
      |> cast(attrs, [:id, :amount, :available_on, :created, :description,
           :exchange_rate, :fee, :fee_details, :net, :status, :type])
      |> validate_inclusion(:object, ["balance_transaction"])
      |> validate_required([:id])
  end
end
