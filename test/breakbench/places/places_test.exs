defmodule Breakbench.PlacesTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Places

  describe "spaces" do
    alias Breakbench.Places.Space

    @update_attrs %{email: "updated.email@example.com"}

    test "list_spaces/0 returns all spaces" do
      [space_one, space_two] = insert_pair(:space)
      assert Enum.map(Places.list_spaces(), &(&1.id)) == Enum.map([space_one, space_two], &(&1.id))
    end

    test "get_space!/1 returns the space with given id" do
      space = insert(:space)
      assert Places.get_space!(space.id).id == space.id
    end

    test "update_space/2 with valid data updates the space" do
      space = insert(:space)
      assert {:ok, space} = Places.update_space(space, @update_attrs)
      assert %Space{} = space
      assert space.email == @update_attrs.email
    end

    test "delete_space/1 deletes the space" do
      space = insert(:space)
      assert {:ok, %Space{}} = Places.delete_space(space)
      assert_raise Ecto.NoResultsError, fn -> Places.get_space!(space.id) end
    end

    test "change_space/1 returns a space changeset" do
      space = insert(:space)
      assert %Ecto.Changeset{} = Places.change_space(space)
    end
  end
end
