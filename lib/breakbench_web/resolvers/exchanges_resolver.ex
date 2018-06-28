defmodule BreakbenchWeb.ExchangesResolver do
  alias Breakbench.Exchanges

  def all_currencies(_root, _args, _info) do
    currencies = Exchanges.list_currencies()
    {:ok, currencies}
  end
end
