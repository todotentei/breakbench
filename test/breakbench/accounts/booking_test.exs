defmodule Breakbench.BookingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Accounts

  describe "bookings" do
    alias Breakbench.Accounts.Booking

    setup do
      field = insert(:field)
      insert(:booking, field: field, kickoff: ~N[2018-07-08 00:00:00])

      {:ok, field: field}
    end


    @valid_attrs %{kickoff: ~N[2018-07-08 01:00:00], duration: 60, field_id: nil}
    @invalid_attrs %{kickoff: ~N[2018-07-08 00:30:00], duration: 60, field_id: nil}

    test "create/1 with a not unique booking raises error", context do
      invalid_attrs = %{@invalid_attrs | field_id: context[:field].id}
      assert_raise Postgrex.Error, fn -> Accounts.create_booking(invalid_attrs) end
    end

    test "create/1 with a unique booking returns a booking", context do
      valid_attrs = %{@valid_attrs | field_id: context[:field].id}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end

    test "create/1 with a not unique booking on different field returns a booking" do
      new_field = insert(:field)
      valid_attrs = %{@invalid_attrs | field_id: new_field.id}
      assert {:ok, %Booking{}} = Accounts.create_booking(valid_attrs)
    end
  end
end
