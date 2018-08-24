defmodule Breakbench.QueueCoreTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.GeoHelper

  alias Breakbench.Matchmaking.MatchmakingQueue
  alias Breakbench.MMOperator.Cores.QueueCore


  describe "mm_operator queue core" do
    @location %{lat: -37.845565, lng: 145.117179}

    setup do
      geom = GeoHelper.latlng_to_point(@location)

      user = insert(:user)
      rule = insert(:matchmaking_rule)
      game_mode = insert(:game_mode)

      space = insert(:space, geom: geom)
      area = insert(:area, space: space)
      game_area = insert(:game_area, area: area)
      # Add game mode to game area
      insert(:game_area_mode, game_area: game_area, game_mode: game_mode)

      {:ok, user: user, rule: rule, game_mode: game_mode}
    end

    test "run/4 with a valid attrs returns matchmaking_queue",
         %{user: user, rule: rule, game_mode: game_mode} do
      geom = GeoHelper.latlng_to_point(@location)
      assert {:ok, %MatchmakingQueue{}} = QueueCore.run(user, rule, geom, [game_mode])
    end
  end
end
