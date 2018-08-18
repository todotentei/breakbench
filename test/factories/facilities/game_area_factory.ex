defmodule Breakbench.Facilities.GameAreaFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Facilities.{
        AffectedGameArea, GameArea, GameAreaClosingHour, GameAreaDynamicPricing,
        GameAreaMode
      }

      def affected_game_area_factory do
        %AffectedGameArea{
          game_area: build(:game_area),
          affected: build(:game_area)
        }
      end

      def game_area_factory do
        %GameArea{
          name: "name",
          area: build(:area),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end

      def game_area_closing_hour_factory do
        %GameAreaClosingHour{
          time_block: build(:time_block),
          game_area: build(:game_area)
        }
      end

      def game_area_dynamic_pricing_factory do
        %GameAreaDynamicPricing{
          time_block: build(:time_block),
          game_area: build(:game_area),
          price: 1000
        }
      end

      def game_area_mode_factory do
        %GameAreaMode{
          game_area: build(:game_area),
          game_mode: build(:game_mode)
        }
      end
    end
  end
end
