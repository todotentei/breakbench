defmodule Breakbench.MMOperator.TransferCore do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.{
    Accounts, Exchanges, Facilities
  }

  alias Breakbench.MMOperator.ServiceFeeUtil

  alias Breakbench.Accounts.Match
  alias Breakbench.StripeAPIs.Transfer


  def run(%Match{} = match) do
    Repo.transaction fn ->
      transferring(match)
    end
  end


  ## Private

  defp transferring(match) do
    try do
      booking = Accounts.get_booking!(match)
      space = Facilities.get_space!(booking)

      currency = Exchanges.get_currency!(booking)

      service_fee = ServiceFeeUtil.host(booking)
      dest_amount = booking.price - service_fee

      with {:ok, %{id: id, object: "transfer"}} <- Transfer.create(%{
        currency: currency.code,
        amount: dest_amount,
        destination: space.stripe_account,
        transfer_group: match.stripe_transfer_group
      }) do
        update_attrs = %{stripe_transfer: id}
        case Accounts.update_booking(booking, update_attrs) do
          {:ok, booking} -> booking
          {:error, _} -> :error
        end
      end
    rescue
      _ -> Repo.rollback(:argument_error)
    end
  end
end
