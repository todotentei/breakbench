defmodule Breakbench.Customer.SourceStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "source"
  stripe "customers", "sources", StripePaymentMethods.Source do
    @doc """
    Attaches a Source object to a Customer. The source must be in a chargeable
    state.
    """
    use_action :attach, [parent_id, data] do
      resource = "#{path()}/#{parent_id}/#{subpath()}"
      case request(:post, resource, data, parse: true) do
        {:ok, %{object: _, id: id, customer: customer}} ->
          changes = %{customer: customer}

          source = StripePaymentMethods.get_source!(id)
          {:ok, associations(source, changes)}
        error -> error
      end
    end

    @doc """
    Detaches a Source object from a Customer. The status of a source is changed
    to consumed when it is detached and it can no longer be used to create a
    charge.
    """
    use_action :detach, [parent_id, id] do
      resource = "#{path()}/#{parent_id}/#{subpath()}/#{id}"
      case request(:delete, resource, %{}, parse: true) do
        {:ok, %{object: _, id: id, status: status}} ->
          changes = %{status: status}

          source = StripePaymentMethods.get_source!(id)
          StripePaymentMethods.update_source(source, changes)
      end
    end


    parse_field :created, unix do
      DateTime.from_unix!(unix)
    end


    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :customer, Breakbench.CustomerStripe
  end
end
