defmodule Breakbench.UserTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Accounts

  describe "users" do
    alias Breakbench.Accounts.User

    @update_attrs %{username: "updated_username", email: "updated.email@example.com"}
    @invalid_attrs %{username: nil, email: nil}
    @not_unique_attrs %{username: "username", email: "email", full_name: "full_name"}

    test "list_users/0 returns all users" do
      [user_one, user_two] = insert_pair(:user)
      assert Accounts.list_users() == [user_one, user_two]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with a non-unique email or username returns error changeset" do
      insert(:user, username: "username", email: "email")
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@not_unique_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.username == @update_attrs.username
      assert user.email == @update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
