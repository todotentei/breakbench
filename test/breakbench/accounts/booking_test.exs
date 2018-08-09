defmodule Breakbench.BookingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Accounts

  describe "bookings" do
    alias Breakbench.Accounts.Booking

    setup do
      user = insert(:user)
      field = insert(:field)
      game_mode = insert(:game_mode)

      insert(:booking, user: user, field: field, kickoff: ~N[2018-07-08 00:00:00])

      {:ok, user: user, field: field, game_mode: game_mode}
    end


    @valid_attrs %{kickoff: ~N[2018-07-08 01:00:00], duration: 60, field_id: nil, game_mode_id: nil, user_id: nil}
    @invalid_attrs %{kickoff: ~N[2018-07-08 00:30:00], duration: 60, field_id: nil, game_mode_id: nil, user_id: nil}

    test "create/1 with a not unique booking raises error", context do
      invalid_attrs = %{@invalid_attrs | field_id: context[:field].id,
        game_mode_id: context[:game_mode].id, user_id: context[:user].id}
      assert_raise Postgrex.Error, fn -> Accounts.create_booking(invalid_attrs) end
    end

    test "create/1 with a unique booking returns a booking", context do
      valid_attrs = %{@valid_attrs | field_id: context[:field].id,
        game_mode_id: context[:game_mode].id, user_id: context[:user].id}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end

    test "create/1 with a not unique booking on different field returns a booking", context do
      new_field = insert(:field)
      valid_attrs = %{@invalid_attrs | field_id: new_field.id,
        game_mode_id: context[:game_mode].id, user_id: context[:user].id}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end
  end
end
