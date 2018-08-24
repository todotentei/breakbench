defmodule Breakbench.MMOperator.Utils.ServiceFeeUtil do
  @moduledoc false

  alias Breakbench.Facilities
  alias Breakbench.Accounts.Booking


  def host(%Booking{} = booking) do
    space = Facilities.get_space!(booking)

    booking.price * space.service_fee
    |> :math.ceil()
    |> round()
  end
end
