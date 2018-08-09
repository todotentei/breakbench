defmodule Breakbench.Accounts.BookingFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Accounts.Booking

      def booking_factory do
        %Booking{
          kickoff: NaiveDateTime.utc_now,
          duration: 3600,
          field: build(:field),
          game_mode: build(:game_mode),
          user: build(:user),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end
    end
  end
end
