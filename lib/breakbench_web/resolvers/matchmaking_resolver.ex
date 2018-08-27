defmodule BreakbenchWeb.MatchmakingResolver do
  @moduledoc false

  alias Breakbench.Matchmaking


  def list_travel_modes(_root, _args, _info) do
    travel_modes = Matchmaking.list_travel_modes()
    {:ok, travel_modes}
  end
end
