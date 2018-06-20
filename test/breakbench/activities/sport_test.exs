defmodule Breakbench.SportTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Activities

  describe "sports" do
    alias Breakbench.Activities.Sport

    @update_attrs %{type: "updated_type"}

    test "list_sports/0 returns all sport" do
      [sport_one, sport_two] = insert_pair(:sport)
      assert Activities.list_sports() == [sport_one, sport_two]
    end

    test "get_sport!/1 returns the sport with given id" do
      sport = insert(:sport)
      assert Activities.get_sport!(sport.name) == sport
    end

    test "update_sport/2 with valid data updates the sport" do
      sport = insert(:sport)
      assert {:ok, sport} = Activities.update_sport(sport, @update_attrs)
      assert %Sport{} = sport
      assert sport.type == @update_attrs.type
    end

    test "delete_sport/1 deletes the sport" do
      sport = insert(:sport)
      assert {:ok, %Sport{}} = Activities.delete_sport(sport)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_sport!(sport.name) end
    end

    test "change_sport/1 returns a sport changeset" do
      sport = insert(:sport)
      assert %Ecto.Changeset{} = Activities.change_sport(sport)
    end
  end
end
