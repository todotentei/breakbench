defmodule Breakbench.LocalityFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.AddressComponents.Locality

      def locality_factory do
        %Locality{
          short_name: sequence(:short_name, &"short-name-#{&1}"),
          long_name: sequence(:long_name, &"long-name-#{&1}"),
          country: build(:country)
        }
      end
    end
  end
end
