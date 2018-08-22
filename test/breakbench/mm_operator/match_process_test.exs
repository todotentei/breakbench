defmodule Breakbench.MatchProcessTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.GeoHelper
  alias Breakbench.Accounts.Match

  alias Breakbench.MMOperator.MatchProcess


  describe "mm_operator match process" do
    @location %{lat: -37.845565, lng: 145.117179}

    setup do
      # Convert location into postgis geometry 4326
      geom = GeoHelper.latlng_to_point(@location)

      sport = insert(:sport)
      rule = insert(:matchmaking_rule)
      game_mode = insert(:game_mode, sport: sport, number_of_players: 2)

      space = insert(:space, geom: geom)
      area = insert(:area, space: space)
      game_area = insert(:game_area, area: area)
      # Add game mode to game area
      insert(:game_area_mode, game_area: game_area, game_mode: game_mode)
      # Create 24/7 space opening hours
      Enum.each 1..7, fn day_of_week ->
        open_time = insert(:time_block, day_of_week: day_of_week)
        insert(:space_opening_hour, space: space, time_block: open_time)
      end

      # Add 2 queuers to match game mode required number of players

      Enum.each 1..2, fn _ ->
        queue = insert(:matchmaking_queue, rule: rule, geom: geom)
        insert(:matchmaking_game_mode, matchmaking_queue: queue, game_mode: game_mode)
        insert(:matchmaking_space_distance_matrix, space: space, matchmaking_queue: queue)
      end

      {:ok, space: space, game_mode: game_mode}
    end

    test "run/2 with valid attrs returns a match",
         %{space: space, game_mode: game_mode} do
      assert {:ok, %Match{}} = MatchProcess.run(space, game_mode)
    end
  end
end
