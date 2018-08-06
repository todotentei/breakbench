defmodule Breakbench.GameModeFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Activities.GameMode

      def game_mode_factory do
        %GameMode{
          name: sequence("game-mode"),
          number_of_players: Enum.random(1..10),
          duration: Enum.random([1800, 2700, 3600]),
          sport: build(:sport),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end
    end
  end
end
