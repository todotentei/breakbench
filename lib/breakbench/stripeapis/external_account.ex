defmodule Breakbench.StripeAPIs.ExternalAccount do
  @moduledoc "Stripe ExternalAccount"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  When you create a new bank account, you must specify a Custom account to
  create it on.

  If the bank account's owner has no other external account in the bank account's
  currency, the new bank account will become the default for that currency.
  However, if the owner already has a bank account for that currency, the new
  account will become the default only if the default_for_currency parameter
  is set to true.

  When you create a new credit card, you must specify a Custom account to create
  it on.

  If the account has no default destination card, then the new card will become
  the default. However, if the owner already has a default then it will not change.
  To change the default, you should set default_for_currency to true when creating
  a card for a Custom account.
  """
  def create(id, data) do
    resource = Path.join(["accounts", id, "external_accounts"])
    request(:post, resource, data)
  end

  @doc """
  By default, you can see the 10 most recent external accounts stored on a
  Custom account directly on the object, but you can also retrieve details
  about a specific bank account stored on the Custom account.
  """
  def retrieve(id, external_id) do
    resource = Path.join(["accounts", id, "external_accounts", external_id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the metadata of a bank account belonging to a Custom account, and
  optionally sets it as the default for its currency. Other bank account details
  are not editable by design.

  You can re-enable a disabled bank account by performing an update call
  without providing any arguments or changes.

  If you need to update only some card details, like the billing address or
  expiration date, you can do so without having to re-enter the full card details.
  Stripe also works directly with card networks so that your customers can continue
  using your service without interruption.
  """
  def update(id, external_id, data) do
    resource = Path.join(["accounts", id, "external_accounts", external_id])
    request(:post, resource, data)
  end

  @doc """
  You can delete destination bank accounts from a Custom account.

  If a bank account's default_for_currency property is true, it can only be
  deleted if it is the only external account for that currency, and the currency
  is not the Stripe account's default currency. Otherwise, before deleting
  the account, you must set another external account to be the default for the
  currency.

  You can delete cards from a managed account.

  If a card's default_for_currency property is true, it can only be deleted if
  it is the only external account for that currency, and the currency is not
  the Stripe account's default currency. Otherwise, before deleting the card,
  you must set another external account to be the default for the currency.
  """
  def delete(id, external_id) do
    resource = Path.join(["accounts", id, "external_accounts", external_id])
    request(:delete, resource, %{})
  end

  @doc """
  You can see a list of the bank accounts and cards belonging to a Custom account.
  Note that the 10 most recent external accounts are always available by default
  on the corresponding Stripe object. If you need more that those 10, you can use
  this API method and the limit and starting_after parameters to page through
  additional bank accounts or cards.
  """
  def list(id, data \\ %{}) do
    resource = Path.join(["accounts", id, "external_accounts"])
    request(:get, resource, data)
  end
end
