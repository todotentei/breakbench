defmodule Breakbench.TransferStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeConnect


  stripe_object "transfer"
  stripe "transfers", StripeConnect.Transfer do
    @doc """
    To send funds from your Stripe account to a connected account, you create a
    new transfer object. Your Stripe balance must be able to cover the transfer
    amount, or you'll receive an "Insufficient Funds" error.
    """
    use_default_action :create

    @doc """
    Retrieves the details of an existing transfer. Supply the unique transfer ID
    from either a transfer creation request or the transfer list, and Stripe will
    return the corresponding transfer information.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified transfer by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.

    This request accepts only metadata as an argument.
    """
    use_default_action :update

    @doc """
    Returns a list of existing transfers sent to connected accounts. The transfers
    are returned in sorted order, with the most recently created transfers appearing
    first.
    """
    use_default_action :list


    parse_field :created, unix do
      DateTime.from_unix!(unix)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :balance_transaction, Breakbench.BalanceTransactionStripe
    belongs_to :destination, Breakbench.AccountStripe
    belongs_to :source_transaction, Breakbench.ChargeStripe
  end
end
