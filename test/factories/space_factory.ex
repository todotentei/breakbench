defmodule Breakbench.SpaceFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Places.Space

      def space_factory do
        %Space{
          id: sequence(:code, &"space-#{&1}"),
          owner: build(:user),
          currency: build(:currency),
          phone: "0123 456 789",
          email: sequence(:email, &"email-#{&1}@example.com"),
          website: "website.com",
          about: "About",
          address: "1 Street Name, Suburb, State Country 0001",
          latitude: 00.000000,
          longitude: 01.000000,
          timezone: "Australia/Melbourne",
          locality: build(:locality)
        }
      end
    end
  end
end