defmodule Breakbench.RefundStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeResources

  stripe_object "refund"
  stripe "refunds", StripeResources.Refund do
    @doc """
    When you create a new refund, you must specify a charge on which to create it.

    Creating a new refund will refund a charge that has previously been created
    but not yet refunded. Funds will be refunded to the credit or debit card that
    was originally charged.

    You can optionally refund only part of a charge. You can do so multiple times,
    until the entire charge has been refunded.

    Once entirely refunded, a charge can't be refunded again. This method will
    return an error when called on an already-refunded charge, or when trying to
    refund more money than is left on a charge.
    """
    use_default_action :create

    @doc """
    Retrieves the details of an existing refund.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified refund by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.

    This request only accepts metadata as an argument.
    """
    use_default_action :update

    @doc """
    Returns a list of all refunds you’ve previously created. The refunds are
    returned in sorted order, with the most recent refunds appearing first.
    For convenience, the 10 most recent refunds are always available by default
    on the charge object.
    """
    use_default_action :list


    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :currency, Breakbench.Currency, sync: false
    belongs_to :balance_transaction, Breakbench.BalanceTransactionStripe
    belongs_to :charge, Breakbench.ChargeStripe
  end
end
