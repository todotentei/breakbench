defmodule Breakbench.Account.CardStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "card"
  stripe "accounts", "external_accounts", StripePaymentMethods.Card do
    @doc """
    When you create a new credit card, you must specify a Custom account to create
    it on.

    If the account has no default destination card, then the new card will become
    the default. However, if the owner already has a default then it will not change.
    To change the default, you should set default_for_currency to true when creating
    a card for a Custom account.
    """
    use_default_action :create

    @doc """
    By default, you can see the 10 most recent external accounts stored on a Custom
    account directly on the object, but you can also retrieve details about a specific
    card stored on the Custom account.
    """
    use_default_action :retrieve

    @doc """
    If you need to update only some card details, like the billing address or
    expiration date, you can do so without having to re-enter the full card details.
    Stripe also works directly with card networks so that your customers can continue
    using your service without interruption.
    """
    use_default_action :update

    @doc """
    You can delete cards from a managed account.

    If a card's default_for_currency property is true, it can only be deleted if
    it is the only external account for that currency, and the currency is not
    the Stripe account's default currency. Otherwise, before deleting the card,
    you must set another external account to be the default for the currency.
    """
    use_default_action :delete

    @doc """
    You can see a list of the cards belonging to a Custom account. Note that the
    10 most recent external accounts are available on the account object. If you
    need more than those 10, you can use this API method and the limit and starting_after
    parameters to page through additional cards.
    """
    use_default_action :list, data: %{object: "card"}


    belongs_to :country, Breakbench.AddressComponents.Country, sync: false
    belongs_to :currency, Breakbench.Currency, sync: false
    belongs_to :account, Breakbench.AccountStripe
  end
end
