defmodule Breakbench.Accounts.BookingFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Accounts.Booking

      def booking_factory do
        %Booking{
          kickoff: NaiveDateTime.utc_now,
          duration: 60,
          field: build(:field),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end
    end
  end
end
