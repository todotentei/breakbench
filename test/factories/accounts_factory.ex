defmodule Breakbench.AccountsFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Accounts.BookingFactory
      use Breakbench.Accounts.MatchFactory
      use Breakbench.Accounts.UserFactory
    end
  end
end
