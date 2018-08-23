defmodule Breakbench.Balances.OutstandingBalanceFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Balances.OutstandingBalance

      def outstanding_balance_factory do
        %OutstandingBalance{
          amount: sequence(:amount, [1000, 2000, 3000]),
          user: build(:user),
          currency: build(:currency)
        }
      end
    end
  end
end
