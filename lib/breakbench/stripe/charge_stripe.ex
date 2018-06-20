defmodule Breakbench.ChargeStripe do
  use Breakbench.Stripe.Object
  alias Breakbench.StripeResources


  stripe_object "charge"
  stripe "charges", StripeResources.Charge do
    @doc """
    To charge a credit card or other payment source, you create a Charge object.
    """
    use_default_action :create

    @doc """
    Retrieves the details of a charge that has previously been created. Supply the
    unique charge ID that was returned from you previous request, and Stripe will
    return the corresponding charge information. The same information is returned
    when creating or refunding the charge.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified charge by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.
    """
    use_default_action :update

    @doc """
    Returns a list of charges you’ve previously created. The charges arereturned
    in sorted order, with the most recent charges appearing first.
    """
    use_default_action :list

    @doc """
    Capture the payment of an existing, uncaptured, charge. This is the second half,
    of the two-step payment flow, where first you created a charge with the capture
    option set to false.

    Uncaptured payments expire exactly seven days after they are created. If they
    are not captured by that point in time, they will be marked as refunded and
    will no longer be captured.
    """
    use_action :capture, [id, data] do
      case request(:post, "#{path()}/#{id}/capture", data, parse: true) do
        {:ok, %{object: _, id: id} = attrs} ->
          charge = StripeResources.get_charge!(id)
          Breakbench.Repo.update(charge, attrs)
        error -> error
      end
    end


    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :balance_transaction, Breakbench.BalanceTransactionStripe
    belongs_to :customer, Breakbench.CustomerStripe
    belongs_to :destination, Breakbench.AccountStripe
    belongs_to :on_behalf_of, Breakbench.AccountStripe
    belongs_to :source_transfer, Breakbench.TransferStripe
    belongs_to :transfer, Breakbench.TransferStripe
  end
end
