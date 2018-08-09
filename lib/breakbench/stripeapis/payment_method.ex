defmodule Breakbench.StripeAPIs.PaymentMethod do
  @moduledoc "Stripe PaymentMethod"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  When you create a new bank account or card, you must specify a Customer object
  on which to create it.

  If the card's owner has no default card, then the new card will become the
  default. However, if the owner already has a default, then it will not
  change. To change the default, you should either update the customer to
  have a new default_source, or update the recipient to have a new default_card.
  """
  def create(id, data) do
    resource = Path.join(["customers", id, "sources"])
    request(:post, resource, data)
  end

  @doc """
  By default, you can see the 10 most recent sources stored on a Customer
  directly on the object, but you can also retrieve details about a specific
  bank account or card stored on the Stripe customer.
  """
  def retrieve(id, method_id) do
    resource = Path.join(["customers", id, "sources", method_id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the account_holder_name, account_holder_type, and metadata of a
  bank account belonging to a customer. Other bank account details are not
  editable, by design.

  If you need to update only some card details, like the billing address or
  expiration date, you can do so without having to re-enter the full card details.
  Also, Stripe works directly with card networks so that your customers can
  continue using your service without interruption.

  When you update a card, Stripe will automatically validate the card.
  """
  def update(id, method_id, data) do
    resource = Path.join(["customers", id, "sources", method_id])
    request(:post, resource, data)
  end

  @doc """
  You can delete bank accounts and card from a Customer.

  If you delete a card that is currently the default source, then the most
  recently added source will become the new default. If you delete a card
  that is the last remaining source on the customer, then the default_source
  attribute will become null.
  """
  def delete(id, method_id) do
    resource = Path.join(["customers", id, "sources", method_id])
    request(:delete, resource, %{})
  end

  @doc """
  You can see a list of the bank accounts and cards belonging to a Customer.
  Note that the 10 most recent sources are always available by default on the
  Customer. If you need more than those 10, you can use this API method and the
  limit and starting_after parameters to page through additional sources.
  """
  def list(id, data \\ %{}) do
    resource = Path.join(["customers", id, "sources"])
    request(:get, resource, data)
  end

  @doc """
  A customer's bank account must first be verified before it can be charged.
  Stripe supports instant verification using Plaid for many of the most
  popular banks. If your customer's bank is not supported or you do not wish
  to integrate with Plaid, you must manually verify the customer's bank account
  using the API.
  """
  def verify(id, bank_id, data) do
    resource = Path.join(["customers", id, "sources", bank_id, "verify"])
    request(:post, resource, data)
  end
end
