defmodule Breakbench.AccountStripe do
  use Breakbench.Stripe.Object

  alias Breakbench.StripeConnect


  stripe_object "account"
  stripe "accounts", StripeConnect.Account do
    @doc """
    With Connect, you can create Stripe accounts for your users.
    """
    use_default_action :create

    @doc """
    Retrieves the details of the account.
    """
    use_default_action :retrieve

    @doc """
    Updates a connect account by setting the values of the parameters passed.
    Any parameters not provided are left unchanged.
    """
    use_default_action :update

    @doc """
    Custom accounts created using live-mode keys may only be deleted once all
    balances are zero.
    """
    use_default_action :delete

    @doc """
    Custom accounts created using live-mode keys may only be deleted once all
    balances are zero.
    """
    use_default_action :list

    @doc """
    Accounts created using live-mode keys may only be rejected once all balances
    are zero.
    """
    use_action :reject, [id, data] do
      case request(:post, "#{path()}/#{id}/reject", data, parse: true) do
        {:ok, %{object: _, id: id} = attrs} ->
          account = StripeConnect.get_account!(id)
          Breakbench.Repo.update(account, attrs)
        error -> error
      end
    end


    parse_field :created, time do
      DateTime.from_unix!(time)
    end


    belongs_to :country, Breakbench.Places.Country, sync: false
    belongs_to :default_currency, Breakbench.Exchanges.Currency, sync: false
  end
end
