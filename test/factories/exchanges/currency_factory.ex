defmodule Breakbench.Exchanges.CurrencyFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Exchanges.Currency

      def currency_factory do
        %Currency{
          code: sequence(:code, &"Code-#{&1}"),
          decimal_digits: 2,
          name: sequence(:name, &"Currency-#{&1} Dollar"),
          name_plural: sequence(:name_plural, &"Currency-#{&1} Dollars"),
          symbol: "$",
          symbol_native: "$"
        }
      end
    end
  end
end
