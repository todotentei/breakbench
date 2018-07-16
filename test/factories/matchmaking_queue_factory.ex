defmodule Breakbench.MatchmakingQueueFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Activities.MatchmakingQueue

      def matchmaking_queue_factory do
        %MatchmakingQueue{
          geom: %Geo.Point{
            coordinates: {
              (:rand.uniform() * 360 - 180),
              (:rand.uniform() * 180 - 90)
            },
            srid: 4326
          },
          travel_mode: sequence(:travel_mode, ["driving", "walking", "bicycling", "transit"]),
          mood: sequence(:mood, ["busy", "chill"]),
          kickoff_from: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
          kickoff_through: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
          status: "queued",
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end
    end
  end
end
