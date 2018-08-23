defmodule Breakbench.MMOperator.Payment do
  @moduledoc false
  use GenServer

  alias Breakbench.{
    Accounts, Exchanges
  }

  alias Breakbench.Accounts.Match

  alias Breakbench.MMOperator.{
    ChargeCore, GamePriceUtil
  }


  @doc false
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  @doc """
  Charge entire match
  """
  def charge(%Match{} = match) do
    GenServer.cast(__MODULE__, {:charge, match})
  end


  ## Callbacks

  def init(_arg), do: {:ok, []}
  def terminate(_reason, _state), do: :ok

  def handle_cast({:charge, match}, state) do
    booking = Accounts.get_booking!(match)
    members = Accounts.list_match_members(match)

    currency = Exchanges.get_currency!(booking)
    split_amount = GamePriceUtil.each(match)

    for member <- members do
      ChargeCore.run(member, currency, split_amount)
    end

    {:noreply, state}
  end
end
