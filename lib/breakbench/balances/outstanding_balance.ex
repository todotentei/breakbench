defmodule Breakbench.Balances.OutstandingBalance do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "outstanding_balances" do
    field :amount, :integer

    belongs_to :user, Breakbench.Accounts.User,
      primary_key: true
    belongs_to :currency, Breakbench.Exchanges.Currency,
      primary_key: true, type: :string, foreign_key: :currency_code, references: :code
  end

  @doc false
  def changeset(outstanding_balance, attrs) do
    outstanding_balance
    |> cast(attrs, [:amount, :user_id, :currency_code])
    |> validate_required([:amount, :user_id, :currency_code])
  end
end
