defmodule Breakbench.ActivitiesFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Activities.GameModeFactory
      use Breakbench.Activities.SportFactory
    end
  end
end
