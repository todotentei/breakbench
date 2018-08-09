defmodule Breakbench.Timesheets.TimeBlockFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Timesheets.TimeBlock

      def time_block_factory do
        %TimeBlock{
          day_of_week: 1,
          start_time: :calendar.time_to_seconds(:erlang.time),
          end_time: :calendar.time_to_seconds(:erlang.time),
          from_date: Date.utc_today,
          through_date: Date.utc_today
        }
      end
    end
  end
end
