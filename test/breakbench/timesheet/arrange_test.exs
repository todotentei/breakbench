defmodule Breakbench.ArrangeTest do
  use Breakbench.DataCase

  alias Breakbench.TimeBlock.Arrange

  import Breakbench.TimeBlock.ValidPeriod, only:
    [to_valid_from: 1, to_valid_through: 1]


  describe "arrange" do
    @time_blocks [%{
      day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]
    }, %{
      day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00]
    }]

    @new_block %{day_of_week: 1, start_at: ~T[03:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}


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

      insert_state = Arrange.lookup_state(uid, :insert)
      delete_state = Arrange.lookup_state(uid, :delete)

      assert Enum.any?(insert_state, fn time_block ->
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[05:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-05 00:00:00])
      end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[03:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-03 00:00:00])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[05:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-03 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-05 00:00:00])
      ) end)
    end


    @time_blocks [%{
      day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: nil, valid_through: nil
    }]

    @new_block %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[04:00:00],
      valid_from: ~N[2018-07-02 00:00:00], valid_through: ~N[2018-07-04 00:00:00]}

    @doc """

       1  2  3  4  5
    1  ─────────────        ───┬─────┬───
    2     ┌─────┐      ->      │     │
    3  ───┼─────┼───        ───┤     ├───
    4     └─────┘              └─────┘

    """
    test "merge infinite valid period with finite" do
      uid = Arrange.merge(@time_blocks, @new_block)

      insert_state = Arrange.lookup_state(uid, :insert)
      delete_state = Arrange.lookup_state(uid, :delete)

      assert Enum.all?(insert_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[03:00:00]) and
        datetime_eq(to_valid_from(time_block.valid_from), to_valid_from(nil)) and
        datetime_eq(time_block.valid_through, ~N[2018-07-02 00:00:00])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[04:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-02 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-04 00:00:00])
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[03:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-04 00:00:00]) and
        datetime_eq(to_valid_through(time_block.valid_through), to_valid_through(nil))
      ) end)

      assert Enum.all?(delete_state, fn time_block -> (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[01:00:00]) and
        time_eq(time_block.end_at, ~T[03:00:00]) and
        datetime_eq(to_valid_from(time_block.valid_from), to_valid_from(nil)) and
        datetime_eq(to_valid_through(time_block.valid_through), to_valid_through(nil))
      ) or (
        time_block.day_of_week == 1 and
        time_eq(time_block.start_at, ~T[02:00:00]) and
        time_eq(time_block.end_at, ~T[04:00:00]) and
        datetime_eq(time_block.valid_from, ~N[2018-07-02 00:00:00]) and
        datetime_eq(time_block.valid_through, ~N[2018-07-04 00:00:00])
      ) end)
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
