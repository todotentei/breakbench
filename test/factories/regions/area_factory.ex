defmodule Breakbench.AreaFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Regions.{
        Area, AreaClosingHour
      }

      def area_factory do
        %Area{space: build(:space)}
      end

      def area_closing_hour_factory do
        %AreaClosingHour{
          time_block: build(:time_block),
          area: build(:area)
        }
      end
    end
  end
end
