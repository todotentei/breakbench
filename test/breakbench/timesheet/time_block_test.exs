defmodule Breakbench.TimeBlockTest do
  use Breakbench.DataCase

  alias Breakbench.TimeBlock

  import Breakbench.TimeBlock.ValidPeriod, only:
    [to_valid_from: 1, to_valid_through: 1]


  describe "combine" do
    @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-05 00:00:00]}
    @time_block2 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00]}

    @doc """

         1  2  3  4  5
      1  ┌─────┬─────┐        ┌─────┬─────┐
      2  │     │     │        │     │     │
      3  └─────┼─────┤   ->   └─────┤     │
      4        │     │              │     │
      5        └─────┘              └─────┘

    """
    test "simple intersect" do
      new_combination = TimeBlock.combine(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[01:00:00]) and
        time_eq(new.end_at, ~T[03:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-03 00:00:00])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[01:00:00]) and
        time_eq(new.end_at, ~T[05:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-03 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-05 00:00:00])
      end)
    end


    @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-02 00:00:00], valid_through: ~N[2018-07-05 00:00:00]}
    @time_block2 %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[04:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-06 00:00:00]}

    @doc """

         1  2  3  4  5  6
      1     ┌────────┐              ┌─────────┐
      2  ┌──┼────────┼──┐        ┌──┤         ├──┐
      3  │  │        │  │   ->   │  │         │  │
      4  └──┼────────┼──┘        └──┤         ├──┘
      5     └────────┘              └─────────┘

    """
    test "exceed valid period" do
      new_combination = TimeBlock.combine(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[02:00:00]) and
        time_eq(new.end_at, ~T[04:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-02 00:00:00])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[02:00:00]) and
        time_eq(new.end_at, ~T[04:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-05 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-06 00:00:00])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[01:00:00]) and
        time_eq(new.end_at, ~T[05:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-02 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-05 00:00:00])
      end)
    end


    @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}
    @time_block2 %{day_of_week: 1, start_at: ~T[03:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}

    @doc """

         1  2
      1  ┌──┐        ┌──┐
      2  │  │        │  │
      3  ├──┤   ->   │  │
      4  │  │        │  │
      5  └──┘        └──┘

    """
    test "overlap edge of time span" do
      new_combination = TimeBlock.combine(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_at, ~T[01:00:00]) and
        time_eq(new.end_at, ~T[05:00:00]) and
        datetime_eq(new.valid_from, ~N[2018-07-01 00:00:00]) and
        datetime_eq(new.valid_through, ~N[2018-07-02 00:00:00])
      end)
    end
  end


  @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[04:00:00],
    valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}
  @time_block2 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[04:00:00],
    valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00]}

  @doc """
       1  2  3  4  5
    1  ┌─────┬─────┐        ┌───────────┐
    2  │     │     │   ->   │           │
    3  │     │     │        │           │
    4  └─────┴─────┘        └───────────┘

  """
  test "the same time span overlap edge of valid period" do
    new_combination = TimeBlock.combine(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[04:00:00]) and
      datetime_eq(new.valid_from, ~N[2018-07-01 00:00:00]) and
      datetime_eq(new.valid_through, ~N[2018-07-05 00:00:00])
    end)
  end


  @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
    valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-04 00:00:00]}
  @time_block2 %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[04:00:00],
    valid_from: ~N[2018-07-02 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}

  @doc """

       1  2  3  4
    1  ┌────────┐        ┌──┬──┬──┐
    2  │  ┌──┐  │        │  │  │  │
    3  │  │  │  │   ->   │  │  │  │
    4  │  └──┘  │        │  │  │  │
    5  └────────┘        └──┴──┴──┘

  """
  test "cover entire block" do
    new_combination = TimeBlock.combine(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[05:00:00]) and
      datetime_eq(new.valid_from, ~N[2018-07-01 00:00:00]) and
      datetime_eq(new.valid_through, ~N[2018-07-02 00:00:00])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[05:00:00]) and
      datetime_eq(new.valid_from, ~N[2018-07-02 00:00:00]) and
      datetime_eq(new.valid_through, ~N[2018-07-03 00:00:00])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[05:00:00]) and
      datetime_eq(new.valid_from, ~N[2018-07-03 00:00:00]) and
      datetime_eq(new.valid_through, ~N[2018-07-04 00:00:00])
    end)
  end


  @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
    valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00]}
  @time_block2 %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[04:00:00],
    valid_from: nil, valid_through: nil}

  @doc """
           3  4  5
    1      ┌─────┐                ┌─────┐
    2  ────┼─────┼────        ────┤     ├────
    3      │     │       ->       │     │
    4  ────┼─────┼────        ────┤     ├────
    5      └─────┘                └─────┘

  """
  test "infinite valid period with finite" do
    new_combination = TimeBlock.combine(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[02:00:00]) and
      time_eq(new.end_at, ~T[04:00:00]) and
      datetime_eq(to_valid_from(new.valid_from), to_valid_from(nil)) and
      datetime_eq(to_valid_through(new.valid_through), ~N[2018-07-03 00:00:00])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[05:00:00]) and
      datetime_eq(to_valid_from(new.valid_from), ~N[2018-07-03 00:00:00]) and
      datetime_eq(to_valid_through(new.valid_through), ~N[2018-07-05 00:00:00])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[02:00:00]) and
      time_eq(new.end_at, ~T[04:00:00]) and
      datetime_eq(to_valid_from(new.valid_from), ~N[2018-07-05 00:00:00]) and
      datetime_eq(to_valid_through(new.valid_through), to_valid_through(nil))
    end)
  end


  @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
    valid_from: nil, valid_through: ~N[2018-07-03 00:00:00]}
  @time_block2 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
    valid_from: ~N[2018-07-03 00:00:00], valid_through: nil}

  @doc """
       1  2  3  4  5
    1  ──────┬──────        ─────────────
    2        │         ->
    3  ──────┴──────        ─────────────

  """
  test "infinite valid_from with infinite valid_through" do
    new_combination = TimeBlock.combine(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[03:00:00]) and
      datetime_eq(to_valid_from(new.valid_from), to_valid_from(nil)) and
      datetime_eq(to_valid_through(new.valid_through), to_valid_through(nil))
    end)
  end


  @time_block1 %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[04:00:00],
    valid_from: nil, valid_through: nil}
  @time_block2 %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[05:00:00],
    valid_from: nil, valid_through: nil}

  @doc """

       1  2  3  4  5
    1  ─────────────        ─────────────
    2  ═════════════
    3                  ->
    4  ─────────────
    5  ═════════════        ─────────────

  """
  test "both valid periods are infinite" do
    new_combination = TimeBlock.combine(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_at, ~T[01:00:00]) and
      time_eq(new.end_at, ~T[05:00:00]) and
      datetime_eq(to_valid_from(new.valid_from), to_valid_from(nil)) and
      datetime_eq(to_valid_through(new.valid_through), to_valid_through(nil))
    end)
  end


  ## Private

  defp time_eq(time0, time1) do
    Time.compare(time0, time1) == :eq
  end

  defp datetime_eq(datetime0, datetime1) do
    NaiveDateTime.compare(datetime0, datetime1) == :eq
  end
end
