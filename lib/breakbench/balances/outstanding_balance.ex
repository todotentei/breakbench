defmodule Breakbench.Balances.OutstandingBalance do
  use Ecto.Schema
  import Ecto.Changeset


  schema "outstanding_balances" do
    field :amount, :integer
    field :reason, :string

    belongs_to :user, Breakbench.Accounts.User
    belongs_to :currency, Breakbench.Exchanges.Currency,
      type: :string, foreign_key: :currency_code, references: :code
  end

  @doc false
  def changeset(outstanding_balance, attrs) do
    outstanding_balance
    |> cast(attrs, [:amount, :reason, :user_id, :currency_code])
    |> validate_required([:amount, :reason, :user_id, :currency_code])
  end
end
