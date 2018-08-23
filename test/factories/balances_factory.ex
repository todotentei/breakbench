defmodule Breakbench.BalancesFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Balances.OutstandingBalanceFactory
    end
  end
end
