defmodule Breakbench.BalanceTransactionStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeResources


  stripe_object "balance_transaction"
  stripe "balance/history", StripeResources.BalanceTransaction do
    @doc """
    Retrieves the balance transaction with the given ID.
    """
    use_default_action :retrieve

    @doc """
    Returns a list of transactions that have contributed to the Stripe account
    balance (e.g., charges, transfers, and so forth).

    The transactions are returned in sorted order, with the most recent
    transactions appearing first.
    """
    use_default_action :list


    parse_field :available_on, time do
      DateTime.from_unix!(time)
    end

    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
  end
end
