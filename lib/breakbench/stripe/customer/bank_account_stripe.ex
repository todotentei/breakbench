defmodule Breakbench.Customer.BankAccountStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "bank_account"
  stripe "customers", "sources", StripePaymentMethods.BankAccount do
    @doc """
    When you create a new bank account, you must specify a Customer object on
    which to create it.
    """
    use_default_action :create

    @doc """
    By default, you can see the 10 most recent sources stored on a Customer
    directly on the object, but you can also retrieve details about a specific
    bank account stored on the Stripe customer.
    """
    use_default_action :retrieve

    @doc """
    Updates the account_holder_name, account_holder_type, and metadata of a
    bank account belonging to a customer. Other bank account details are not
    editable, by design.
    """
    use_default_action :update

    @doc """
    You can delete bank accounts from a Customer.
    """
    use_default_action :delete

    @doc """
    You can see a list of the bank accounts belonging to a Customer. Note that
    the 10 most recent sources are always available by default on the Customer.
    If you need more than those 10, you can use this API method and the limit and
    starting_after parameters to page through additional bank accounts.
    """
    use_default_action :list, data: %{object: "bank_account"}

    @doc """
    A customer's bank account must first be verified before it can be charged.
    Stripe supports instant verification using Plaid for many of the most
    popular banks. If your customer's bank is not supported or you do not wish
    to integrate with Plaid, you must manually verify the customer's bank account
    using the API.
    """
    use_action :verify, [parent_id, id, data] do
      resource = "#{path()}/#{parent_id}/#{subpath()}/#{id}/verify"
      case request(:post, resource, data) do
        {:ok, %{object: _, id: id, status: status}} ->
          changes = %{status: status}

          bank_account = StripePaymentMethods.get_bank_account!(id)
          StripePaymentMethods.update_bank_account(bank_account, changes)
      end
    end


    belongs_to :country, Breakbench.AddressComponents.Country, sync: false
    belongs_to :currency, Breakbench.Currency, sync: false
    belongs_to :customer, Breakbench.CustomerStripe
  end
end
