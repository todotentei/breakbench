defmodule Breakbench.ArrangeTest do
  use Breakbench.DataCase

  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }

  import Breakbench.TimeBlock.DateRange, only:
    [valid_from: 1, valid_through: 1]


  describe "arrange" do
    @time_blocks [%{
      day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]
    }, %{
      day_of_week: 1, start_time: 3600, end_time: 18000,
      from_date: ~D[2018-07-03], through_date: ~D[2018-07-05]
    }]

    @new_block %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}


    @doc """

         1  2  3  4  5
      1  ┌─────┬─────┐                      ┌───────────┐
      2  │     │     │                      │           │
      3  └─────┤     │   +   ┌─────┐   ->   │           │
      4        │     │       │     │        │           │
      5        └─────┘       └─────┘        └───────────┘

    """
    test "merge" do
      uid = Arrange.merge(@time_blocks, @new_block)

      insert_state = ArrangeState.lookup_state(uid, :insert)
      delete_state = ArrangeState.lookup_state(uid, :delete)

      assert Enum.any?(insert_state, fn time_block ->
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 18000) and
        date_eq(time_block.from_date, ~D[2018-07-01]) and
        date_eq(time_block.through_date, ~D[2018-07-05])
      end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 10800) and
        date_eq(time_block.from_date, ~D[2018-07-01]) and
        date_eq(time_block.through_date, ~D[2018-07-03])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 18000) and
        date_eq(time_block.from_date, ~D[2018-07-03]) and
        date_eq(time_block.through_date, ~D[2018-07-05])
      ) end)
    end


    @time_blocks [%{
      day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: nil, through_date: nil
    }]

    @new_block %{day_of_week: 1, start_time: 7200, end_time: 14400,
      from_date: ~D[2018-07-02], through_date: ~D[2018-07-04]}

    @doc """

       1  2  3  4  5
    1  ─────────────        ───┬─────┬───
    2     ┌─────┐      ->      │     │
    3  ───┼─────┼───        ───┤     ├───
    4     └─────┘              └─────┘

    """
    test "merge infinite valid period with finite" do
      uid = Arrange.merge(@time_blocks, @new_block)

      insert_state = ArrangeState.lookup_state(uid, :insert)
      delete_state = ArrangeState.lookup_state(uid, :delete)

      assert Enum.all?(insert_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 10800) and
        date_eq(valid_from(time_block.from_date), valid_from(nil)) and
        date_eq(time_block.through_date, ~D[2018-07-02])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 14400) and
        date_eq(time_block.from_date, ~D[2018-07-02]) and
        date_eq(time_block.through_date, ~D[2018-07-04])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 10800) and
        date_eq(time_block.from_date, ~D[2018-07-04]) and
        date_eq(valid_through(time_block.through_date), valid_through(nil))
      ) end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 10800) and
        date_eq(valid_from(time_block.from_date), valid_from(nil)) and
        date_eq(valid_through(time_block.through_date), valid_through(nil))
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 7200) and
        time_eq(time_block.end_time, 14400) and
        date_eq(time_block.from_date, ~D[2018-07-02]) and
        date_eq(time_block.through_date, ~D[2018-07-04])
      ) end)
    end
  end


  ## Private

  defp time_eq(time0, time1) do
    time0 == time1
  end

  defp date_eq(datetime0, datetime1) do
    Date.compare(datetime0, datetime1) == :eq
  end
end
