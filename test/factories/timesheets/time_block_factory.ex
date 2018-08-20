defmodule Breakbench.Timesheets.TimeBlockFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Timesheets.TimeBlock

      def time_block_factory do
        %TimeBlock{
          day_of_week: 1,
          start_time: 0,
          end_time: 86400,
          from_date: nil,
          through_date: nil
        }
      end
    end
  end
end
