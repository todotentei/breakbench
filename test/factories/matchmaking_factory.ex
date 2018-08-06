defmodule Breakbench.MatchmakingFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Matchmaking.{
        MatchmakingAvailabilityMode, MatchmakingGameMode, MatchmakingQueue,
        MatchmakingRule, MatchmakingSpaceDistanceMatrix, MatchmakingTravelMode
      }

      def matchmaking_availability_mode_factory do
        %MatchmakingAvailabilityMode{
          type: sequence(:matchmaking_availability_mode, [
            "strict", "normal", "free"
          ])
        }
      end

      def matchmaking_game_mode_factory do
        %MatchmakingGameMode{
          matchmaking_queue: build(:matchmaking_queue),
          game_mode: build(:game_mode)
        }
      end

      def matchmaking_queue_factory do
        %MatchmakingQueue{
          geom: %Geo.Point{
            coordinates: {
              (:rand.uniform() * 360 - 180),
              (:rand.uniform() * 180 - 90)
            },
            srid: 4326
          },
          rule: build(:matchmaking_rule),
          radius: sequence(:radius, [500, 1000, 2000]),
          status: "queued",
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end

      def matchmaking_rule_factory do
        %MatchmakingRule{
          travel_mode: build(:matchmaking_travel_mode),
          availability_mode: build(:matchmaking_availability_mode),
          max_radius: sequence(:max_radius, [1000, 2000]),
          radius_expansion_rate: 500
        }
      end

      def matchmaking_space_distance_matrix_factory do
        %MatchmakingSpaceDistanceMatrix{
          distance: 3000,
          duration: 1800,
          space: build(:space),
          matchmaking_queue: build(:matchmaking_queue)
        }
      end

      def matchmaking_travel_mode_factory do
        %MatchmakingTravelMode{
          type: sequence(:matchmaking_travel_mode, [
            "driving", "walking", "bicycling", "transit"
          ])
        }
      end
    end
  end
end
