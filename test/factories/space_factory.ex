defmodule Breakbench.SpaceFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Places.{Space, SpaceOpeningHour}

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
          geom: %Geo.Point{
            coordinates: {
              (:rand.uniform() * 360 - 180),
              (:rand.uniform() * 180 - 90)
            },
            srid: 4326
          },
          timezone: "Australia/Melbourne"
        }
      end

      def space_opening_hour_factory do
        %SpaceOpeningHour{
          time_block: build(:time_block),
          space: build(:space)
        }
      end
    end
  end
end
