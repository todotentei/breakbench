defmodule BreakbenchWeb.MatchmakingChannel do
  use BreakbenchWeb, :channel

  alias BreakbenchWeb.Endpoint

  alias Breakbench.{
    Activities, Matchmaking
  }
  alias Breakbench.GeoHelper


  def join("matchmaking:" <> _, _params, socket) do
    {:ok, %{}, socket}
  end

  def handle_in(
    "CREATED_QUEUE",
    %{
      "location" => location,
      "travel_mode" => travel_mode,
      "availability_mode" => availability_mode,
      "sport" => sport,
      "game_modes" => game_modes,
    },
    socket
  ) do
    geom = GeoHelper.latlng_to_point(location)
    sport = Activities.get_sport!(sport)
    rule = Matchmaking.get_rule_by!(%{
      travel_mode_type: travel_mode,
      availability_mode_type: availability_mode
    })
    game_modes = to_game_modes(game_modes)

    Endpoint.broadcast!(socket.topic, "CREATED_QUEUE", %{})

    {:noreply, socket}
  end


  ## Private

  defp to_game_modes(game_modes) do
    Enum.each game_modes, & Activities.get_game_mode!/1
  end
end
