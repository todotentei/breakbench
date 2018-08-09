defmodule Breakbench.ExchangesFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Exchanges.CurrencyFactory
    end
  end
end
