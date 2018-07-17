defmodule Breakbench.Account.BankAccountStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripePaymentMethods


  stripe_object "bank_account"
  stripe "accounts", "external_accounts", StripePaymentMethods.BankAccount do
    @doc """
    When you create a new bank account, you must specify a Custom account to
    create it on.

    If the bank account's owner has no other external account in the bank account's
    currency, the new bank account will become the default for that currency.
    However, if the owner already has a bank account for that currency, the new
    account will become the default only if the default_for_currency parameter
    is set to true
    """
    use_default_action :create

    @doc """
    By default, you can see the 10 most recent external accounts stored on a
    Custom account directly on the object, but you can also retrieve details
    about a specific bank account stored on the Custom account.
    """
    use_default_action :retrieve

    @doc """
    Updates the metadata of a bank account belonging to a Custom account, and
    optionally sets it as the default for its currency. Other bank account details
    are not editable by design.

    You can re-enable a disabled bank account by performing an update call
    without providing any arguments or changes.
    """
    use_default_action :update

    @doc """
    You can delete destination bank accounts from a Custom account.

    If a bank account's default_for_currency property is true, it can only be
    deleted if it is the only external account for that currency, and the currency
    is not the Stripe account's default currency. Otherwise, before deleting
    the account, you must set another external account to be the default for the
    currency.
    """
    use_default_action :delete

    @doc """
    You can see a list of the bank accounts belonging to a Custom account. Note
    that the 10 most recent external accounts are always available by default on
    the corresponding Stripe object. If you need more that those 10, you can use
    this API method and the limit and starting_after parameters to page through
    additional bank accounts.
    """
    use_default_action :list, data: %{object: "bank_account"}


    belongs_to :country, Breakbench.Places.Country, sync: false
    belongs_to :currency, Breakbench.Exchanges.Currency, sync: false
    belongs_to :account, Breakbench.AccountStripe
  end
end
