defmodule Breakbench.BookingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Accounts

  describe "bookings" do
    @default_attrs %{price: 2000, duration: 60, kickoff: nil, game_area_id: nil,
      game_mode_id: nil, user_id: nil, currency_code: nil}

    @valid_attrs %{@default_attrs | kickoff: ~N[2018-07-08 01:00:00]}
    @invalid_attrs %{@default_attrs | kickoff: ~N[2018-07-08 00:30:00]}

    alias Breakbench.Accounts.Booking

    setup do
      user = insert(:user)
      game_area = insert(:game_area)
      game_mode = insert(:game_mode)
      currency = insert(:currency)

      insert(:booking, user: user, game_area: game_area, kickoff: ~N[2018-07-08 00:00:00])

      {:ok, user: user, game_area: game_area, game_mode: game_mode, currency: currency}
    end

    test "create/1 with a not unique booking raises error", %{user: user, game_area: game_area,
         game_mode: game_mode, currency: currency} do
      invalid_attrs = %{@invalid_attrs | game_area_id: game_area.id, game_mode_id: game_mode.id,
        user_id: user.id, currency_code: currency.code}
      assert_raise Postgrex.Error, fn -> Accounts.create_booking(invalid_attrs) end
    end

    test "create/1 with a unique booking returns a booking", %{user: user, game_area: game_area,
         game_mode: game_mode, currency: currency} do
      valid_attrs = %{@valid_attrs | game_area_id: game_area.id, game_mode_id: game_mode.id,
        user_id: user.id, currency_code: currency.code}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end

    test "create/1 with a not unique booking on different game area returns a booking",
         %{user: user, game_mode: game_mode, currency: currency} do
      new_game_area = insert(:game_area)
      valid_attrs = %{@invalid_attrs | game_area_id: new_game_area.id, game_mode_id: game_mode.id,
        user_id: user.id, currency_code: currency.code}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end
  end
end
