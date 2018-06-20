defmodule Breakbench.CurrencyFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Currency

      def currency_factory do
        %Currency{
          code: sequence(:code, &"#{&1}#{&1}#{&1}"),
          decimal_digits: 2,
          name: sequence(:name, &"Currency#{&1} Dollar"),
          name_plural: sequence(:name_plural, &"Currency#{&1} Dollars"),
          symbol: sequence(:symbol, &"#{&1}#{&1}$"),
          symbol_native: "$"
        }
      end
    end
  end
end
