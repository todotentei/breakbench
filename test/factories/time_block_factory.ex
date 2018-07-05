defmodule Breakbench.TimeBlockFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Timesheets.TimeBlock

      def time_block_factory do
        %TimeBlock{
          day_of_week: 1,
          start_at: Time.utc_now,
          end_at: Time.utc_now,
          valid_from: NaiveDateTime.utc_now,
          valid_through: NaiveDateTime.utc_now
        }
      end
    end
  end
end
