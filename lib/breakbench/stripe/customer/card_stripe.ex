defmodule Breakbench.Customer.CardStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "card"
  stripe "customers", "sources", StripePaymentMethods.Card do
    @doc """
    When you create a new credit card, you must specify a customer or recipient
    on which to create it.

    If the card's owner has no default card, then the new card will become the
    default. However, if the owner already has a default, then it will not
    change. To change the default, you should either update the customer to
    have a new default_source, or update the recipient to have a new default_card.
    """
    use_default_action :create

    @doc """
    You can always see the 10 most recent cards directly on a customer; this method
    lets you retrieve details about a specific card stored on the customer.
    """
    use_default_action :retrieve

    @doc """
    If you need to update only some card details, like the billing address or
    expiration date, you can do so without having to re-enter the full card details.
    Also, Stripe works directly with card networks so that your customers can
    continue using your service without interruption.

    When you update a card, Stripe will automatically validate the card.
    """
    use_default_action :update

    @doc """
    You can delete cards from a customer.

    If you delete a card that is currently the default source, then the most
    recently added source will become the new default. If you delete a card
    that is the last remaining source on the customer, then the default_source
    attribute will become null.
    """
    use_default_action :delete

    @doc """
    You can see a list of the cards belonging to a customer. Note that the 10 most
    recent sources are always available on the Customer object. If you need more
    than those 10, you can use this API method and the limit and starting_after
    parameters to page through additional cards.
    """
    use_default_action :list, data: %{object: "card"}


    belongs_to :country, Breakbench.Places.Country, sync: false
    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :customer, Breakbench.CustomerStripe
  end
end
