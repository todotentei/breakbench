defmodule Breakbench.ArrangeTest do
  use Breakbench.DataCase

  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }

  import Breakbench.TimeBlock.DateRange, only:
    [to_from_date: 1, to_through_date: 1]


  describe "arrange" do
    @time_blocks [%{
      day_of_week: 1, start_time: ~T[01:00:00], end_time: ~T[03:00:00],
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]
    }, %{
      day_of_week: 1, start_time: ~T[01:00:00], end_time: ~T[05:00:00],
      from_date: ~D[2018-07-03], through_date: ~D[2018-07-05]
    }]

    @new_block %{day_of_week: 1, start_time: ~T[03:00:00], end_time: ~T[05:00:00],
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
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[05:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-01]) and
        date_eq(time_block.through_date, ~D[2018-07-05])
      end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[03:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-01]) and
        date_eq(time_block.through_date, ~D[2018-07-03])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[05:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-03]) and
        date_eq(time_block.through_date, ~D[2018-07-05])
      ) end)
    end


    @time_blocks [%{
      day_of_week: 1, start_time: ~T[01:00:00], end_time: ~T[03:00:00],
      from_date: nil, through_date: nil
    }]

    @new_block %{day_of_week: 1, start_time: ~T[02:00:00], end_time: ~T[04:00:00],
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
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[03:00:00]) and
        date_eq(to_from_date(time_block.from_date), to_from_date(nil)) and
        date_eq(time_block.through_date, ~D[2018-07-02])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[04:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-02]) and
        date_eq(time_block.through_date, ~D[2018-07-04])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[03:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-04]) and
        date_eq(to_through_date(time_block.through_date), to_through_date(nil))
      ) end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[01:00:00]) and
        time_eq(time_block.end_time, ~T[03:00:00]) and
        date_eq(to_from_date(time_block.from_date), to_from_date(nil)) and
        date_eq(to_through_date(time_block.through_date), to_through_date(nil))
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, ~T[02:00:00]) and
        time_eq(time_block.end_time, ~T[04:00:00]) and
        date_eq(time_block.from_date, ~D[2018-07-02]) and
        date_eq(time_block.through_date, ~D[2018-07-04])
      ) end)
    end
  end


  ## Private

  defp time_eq(time0, time1) do
    Time.compare(time0, time1) == :eq
  end

  defp date_eq(datetime0, datetime1) do
    Date.compare(datetime0, datetime1) == :eq
  end
end
