defmodule Breakbench.MMOperator.Cores.ChargeCore do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.{
    Accounts, Balances
  }

  alias Breakbench.Accounts.MatchMember
  alias Breakbench.Exchanges.Currency
  alias Breakbench.StripeAPIs.Charge


  def run(%MatchMember{} = member, %Currency{} = currency, amount)
      when is_integer(amount) do
    Repo.transaction fn ->
      match = Accounts.get_match!(member)
      user = Accounts.get_user!(member)

      with {:ok, %{id: id, object: "charge"}} <- Charge.create(%{
        customer: user.stripe_customer,
        currency: currency.code,
        amount: amount,
        transfer_group: match.stripe_transfer_group
      }) do
        update_attrs = %{stripe_charge: id}
        case Accounts.update_match_member(member, update_attrs) do
          {:ok, member} -> member
          {:error, _} -> :error
        end
      else {:error, response} ->
        case Balances.create_outstanding_balance(%{
          amount: amount,
          currency_code: currency.code,
          user_id: user.id,
          reason: Map.get(response, :message)
        }) do
          {:ok, outstanding} -> outstanding
          {:error, _} -> :error
        end
      end
    end
  end
end
