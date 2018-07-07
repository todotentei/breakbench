defmodule Breakbench.Field.ClosingHourTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Places, Timesheets}
  alias Breakbench.Places.FieldClosingHour


  describe "field_closing_hours validation" do
    setup do
      field = insert(:field)

      time_block = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[02:00:00],
        valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00])
      insert(:field_closing_hour, field: field, time_block: time_block)

      {:ok, field: field}
    end


    @valid_time_block %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}

    test "unique time_block returns field_closing_hour", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      fch_attrs = %{time_block_id: time_block.id, field_id: context[:field].id}

      assert {:ok, %FieldClosingHour{}} = Places.create_field_closing_hour(fch_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}

    test "not unique time_block raises postgrex error", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fch_attrs = %{time_block_id: time_block.id, field_id: context[:field].id}

      assert_raise Postgrex.Error, fn -> Places.create_field_closing_hour(fch_attrs) end
    end
  end


  describe "field_closing_hours arrangement" do
    alias Breakbench.Field.ClosingHour

    setup do
      field = insert(:field)

      time_block1 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
        valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00])
      time_block2 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
        valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00])

      insert(:field_closing_hour, field: field, time_block: time_block1)
      insert(:field_closing_hour, field: field, time_block: time_block2)

      {:ok, field: field, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_at: ~T[03:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}

    test "insert/2 merges all intersected time_blocks", context do
      ClosingHour.insert(context[:field], @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Places.get_field_closing_hour!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Places.get_field_closing_hour!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      field_closing_hours = Places.list_field_closing_hours()
        |> Repo.preload(:time_block)
      assert Enum.all? field_closing_hours, fn %{time_block: time_block} ->
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[05:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-05 00:00:00])
      end
    end
  end


  ## Private

  defp time_eq(time0, time1) do
    Time.compare(time0, time1) == :eq
  end

  defp datetime_eq(datetime0, datetime1) do
    NaiveDateTime.compare(datetime0, datetime1) == :eq
  end
end
