defmodule Breakbench.MMOperator.Payment do
  @moduledoc false
  use GenServer

  alias Breakbench.{
    Accounts, Exchanges
  }

  alias Breakbench.Accounts.Match

  alias Breakbench.MMOperator.Cores.{
    ChargeCore, TransferCore
  }
  alias Breakbench.MMOperator.Utils.GamePriceUtil


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

  @doc """
  Create transfer to destination
  """
  def transfer(%Match{} = match) do
    GenServer.cast(__MODULE__, {:transfer, match})
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

  def handle_cast({:transfer, match}, state) do
    TransferCore.run(match)
    {:noreply, state}
  end
end
