defmodule BreakbenchWeb.ActivityResolver do
  @moduledoc false
  alias Breakbench.Activities

  # Game mode
  def list_game_modes(_, %{sport: sport}, _) do
    try do
      sport = Activities.get_sport!(sport)
      game_modes = Activities.list_game_modes(sport)

      {:ok, game_modes}
    rescue
      e -> {:error, e.message}
    end
  end
  def list_game_modes(_, _, _) do
    game_modes = Activities.list_game_modes()

    {:ok, game_modes}
  end

  # Sport
  def list_sports(_, _, _) do
    sports = Activities.list_sports()

    {:ok, sports}
  end
end
