defmodule Breakbench.TransferReversalStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeConnect


  stripe_object "transfer_reversal"
  stripe "transfers", "reversals", StripeConnect.TransferReversal do
    @doc """
    When you create a new reversal, you must specify a transfer to create it on.

    When reversing transfers, you can optionally reverse part of the transfer.
    You can do so as many times as you wish until the entire transfer has been
    reversed.

    Once entirely reversed, a transfer can't be reversed again. This method will
    return an error when called on an already-reversed transfer, or when trying
    to reverse more money than is left on a transfer/
    """
    use_default_action :create

    @doc """
    Retrieves details about a specific reversal stored on the transfer.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified reversal by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.

    This request only accepts metadata and description as arguments.
    """
    use_default_action :update

    @doc """
    You can see a list of the reversals belonging to a specific transfer. Note that
    the 10 most recent reversals are always available by default on the transfer
    object. If you need more than those 10, you can use this API method and the
    limit and starting_after parameters to page through additional reversals.
    """
    use_default_action :list


    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :currency, Breakbench.Currency, sync: false
    belongs_to :balance_transaction, Breakbench.BalanceTransactionStripe
    belongs_to :transfer, Breakbench.TransferStripe
  end
end
