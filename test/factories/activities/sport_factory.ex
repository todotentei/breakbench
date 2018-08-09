defmodule Breakbench.Activities.SportFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Activities.Sport

      def sport_factory do
        %Sport{
          name: sequence(:name, &"Name-#{&1}"),
          type: "type"
        }
      end
    end
  end
end
