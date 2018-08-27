defmodule BreakbenchWeb.ActivitiesResolver do
  @moduledoc false

  alias Breakbench.Activities


  def list_sport_game_modes(_root, %{sport: sport}, _info) do
    game_modes = sport
    |> Activities.get_sport!()
    |> Activities.list_game_modes()

    {:ok, game_modes}
  end

  def list_sports(_root, _args, _info) do
    sports = Activities.list_sports()
    {:ok, sports}
  end
end
