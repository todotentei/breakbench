defmodule Breakbench.CountryFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Places.Country

      def country_factory do
        %Country{
          short_name: sequence(:short_name, &"#{&1}#{&1}"),
          long_name: sequence(:long_name, &"Country#{&1}")
        }
      end
    end
  end
end
