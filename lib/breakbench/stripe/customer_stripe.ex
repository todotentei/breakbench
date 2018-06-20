defmodule Breakbench.CustomerStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeResources


  stripe_object "customer"
  stripe "customers", StripeResources.Customer do
    @doc """
    Creates a new customer object.
    """
    use_default_action :create

    @doc """
    Retrieves the details of an existing customer. You need only supply the
    unique customer identifier that was returned upon customer creation.
    """
    use_default_action :retrieve

    @doc """
    Updates the specified customer by setting the values of the parameters passed.
    Any parameters not provided will be left unchanged.
    """
    use_default_action :update

    @doc """
    Permanently deletes a customer. It cannot be undone.
    """
    use_default_action :delete

    @doc """
    Returns a list of your customers. The customers are returned sorted by
    creation date, with the most recent customers appearing first.
    """
    use_default_action :list


    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
  end
end
