defmodule Breakbench.TimeBlockFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Timesheets.TimeBlock

      def time_block_factory do
        %TimeBlock{
          day_of_week: 1,
          start_time: Time.utc_now,
          end_time: Time.utc_now,
          from_date: Date.utc_today,
          through_date: Date.utc_today
        }
      end
    end
  end
end
