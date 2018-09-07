defmodule BreakbenchWeb.MatchmakingNotation do
  use Absinthe.Schema.Notation
  import BreakbenchWeb.MatchmakingResolver

  # Context
  object :matchmaking_queries do
    field :list_matchmaking_travel_modes, list_of(:matchmaking_travel_mode) do
      resolve & list_matchmaking_travel_modes/3
    end
  end

  # Travel Mode
  object :matchmaking_travel_mode do
    field :type, :string
  end
end
