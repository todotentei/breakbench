defmodule Breakbench.GroundFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Places.{Ground, GroundGameMode, GroundClosingHour}

      def ground_factory do
        %Ground{
          id: sequence(:id, &"ground-#{&1}"),
          description: "description",
          default_price: 1000,
          space: build(:space),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end

      def ground_game_mode_factory do
        %GroundGameMode{
          ground: build(:ground),
          game_mode: build(:game_mode),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end

      def ground_closing_hour_factory do
        %GroundClosingHour{
          time_block: build(:time_block),
          ground: build(:ground)
        }
      end
    end
  end
end
