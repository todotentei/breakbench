defmodule Breakbench.StripeAPIs.BalanceTransaction do
  @moduledoc "Stripe BalanceTransaction"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  Retrieves the balance transaction with the given ID.
  """
  def retrieve(id) do
    resource = Path.join(["balance/history", id])
    request(:get, resource, %{})
  end

  @doc """
  Returns a list of transactions that have contributed to the Stripe account
  balance (e.g., charges, transfers, and so forth).

  The transactions are returned in sorted order, with the most recent
  transactions appearing first.
  """
  def list(data \\ %{}) do
    request(:get, "balance/history", data)
  end
end
