defmodule Breakbench.SourceStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "source"
  stripe "sources", StripePaymentMethods.Source do
    @doc """
    Creates a new source object.
    """
    use_default_action :create

    @doc """
    Retrieves an existing source object. Supply the unique source ID from a
    source creation request and Stripe will return the corresponding up-to-date
    source object information.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified source by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.

    This request accepts the metadata and owner as arguments. It is also possible
    to update type specific information for selected payment methods. Please
    refer to our payment method guides for more detail.
    """
    use_default_action :update


    parse_field :created, unix do
      DateTime.from_unix!(unix)
    end


    belongs_to :currency, Breakbench.Currency, sync: false
    belongs_to :customer, Breakbench.CustomerStripe
  end
end
