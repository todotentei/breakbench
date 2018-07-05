defmodule Breakbench.Space.OpeningHourTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  describe "space_opening_hours" do
    alias Breakbench.{Places, Timesheets}
    alias Breakbench.Space.OpeningHour

    @new_time_block %{day_of_week: 1, start_at: ~T[03:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}

    setup do
      space = insert(:space)

      time_block1 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
        valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00])
      time_block2 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
        valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00])

      insert(:space_opening_hour, space: space, time_block: time_block1)
      insert(:space_opening_hour, space: space, time_block: time_block2)

      {:ok, space: space, time_block1: time_block1, time_block2: time_block2}
    end

    test "insert/2 merges all intersections", context do
      OpeningHour.insert(context[:space], @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Places.get_space_opening_hour!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Places.get_space_opening_hour!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      space_opening_hours = Repo.preload(Places.list_space_opening_hours(), :time_block)
      assert Enum.all? space_opening_hours, fn %{time_block: time_block} ->
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
