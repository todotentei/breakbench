defmodule Breakbench.PayoutStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeResources


  stripe_object "payout"
  stripe "payouts", StripeResources.Payout do
    @doc """
    To send funds to your own bank account, you create a new payout object. Your
    Stripe balance must be able to cover the payout amount, or you'll receive an
    "Insufficient Funds" error.

    If you are creating a manual payout on a Stripe account that uses multiple
    payment source types, you'll need to specify he source type balance that the
    payout should draw from. The balance object details available and pending amounts
    by source type.
    """
    use_default_action :create

    @doc """
    Retrieves the details of an existing payout. Supply the unique payout ID from
    either a payout creation request or the payout list, and Stripe will return
    the corresponding payout information.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified payout by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged. This request accepts only
    the metadata as arguments.
    """
    use_default_action :update

    @doc """
    Returns a list of existing payouts sent to third-party bank accounts or that
    Stripe has sent you. The payouts are returned in sorted order, with most recently
    created payouts appearing first.
    """
    use_default_action :list

    @doc """
    A previously created payout can be canceled if it has not yet been paid out.
    Funds will be refunded to your available balance. You may not cancel automatic
    Stripe payouts.
    """
    use_action :cancel, [id] do
      request(:post, "#{path()}/#{id}/cancel", %{})
    end


    parse_field :arrival_date, unix do
      DateTime.from_unix!(unix)
    end

    parse_field :created, unix do
      DateTime.from_unix!(unix)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :balance_transaction, Breakbench.BalanceTransactionStripe
  end
end
