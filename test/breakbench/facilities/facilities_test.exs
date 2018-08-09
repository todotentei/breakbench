defmodule Breakbench.FacilitiesTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Facilities

  describe "spaces" do
    alias Breakbench.Facilities.Space

    @update_attrs %{email: "updated.email@example.com"}

    test "list_spaces/0 returns all spaces" do
      [space_one, space_two] = insert_pair(:space)
      assert Enum.map(Facilities.list_spaces(), &(&1.id)) == Enum.map([space_one, space_two], &(&1.id))
    end

    test "get_space!/1 returns the space with given id" do
      space = insert(:space)
      assert Facilities.get_space!(space.id).id == space.id
    end

    test "update_space/2 with valid data updates the space" do
      space = insert(:space)
      assert {:ok, space} = Facilities.update_space(space, @update_attrs)
      assert %Space{} = space
      assert space.email == @update_attrs.email
    end

    test "delete_space/1 deletes the space" do
      space = insert(:space)
      assert {:ok, %Space{}} = Facilities.delete_space(space)
      assert_raise Ecto.NoResultsError, fn -> Facilities.get_space!(space.id) end
    end

    test "change_space/1 returns a space changeset" do
      space = insert(:space)
      assert %Ecto.Changeset{} = Facilities.change_space(space)
    end
  end
end
