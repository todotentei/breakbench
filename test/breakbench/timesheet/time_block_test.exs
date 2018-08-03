defmodule Breakbench.TimeBlockTest do
  use Breakbench.DataCase

  alias Breakbench.TimeBlock.Merge

  import Breakbench.TimeBlock.DateRange, only:
    [valid_from: 1, valid_through: 1]


  describe "merge" do
    @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-05]}
    @time_block2 %{day_of_week: 1, start_time: 3600, end_time: 18000,
      from_date: ~D[2018-07-03], through_date: ~D[2018-07-05]}

    @doc """

         1  2  3  4  5
      1  ┌─────┬─────┐        ┌─────┬─────┐
      2  │     │     │        │     │     │
      3  └─────┼─────┤   ->   └─────┤     │
      4        │     │              │     │
      5        └─────┘              └─────┘

    """
    test "simple overlap" do
      new_combination = Merge.merge(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 3600) and
        time_eq(new.end_time, 10800) and
        date_eq(new.from_date, ~D[2018-07-01]) and
        date_eq(new.through_date, ~D[2018-07-03])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 3600) and
        time_eq(new.end_time, 18000) and
        date_eq(new.from_date, ~D[2018-07-03]) and
        date_eq(new.through_date, ~D[2018-07-05])
      end)
    end


    @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 18000,
      from_date: ~D[2018-07-02], through_date: ~D[2018-07-05]}
    @time_block2 %{day_of_week: 1, start_time: 7200, end_time: 14400,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-06]}

    @doc """

         1  2  3  4  5  6
      1     ┌────────┐              ┌─────────┐
      2  ┌──┼────────┼──┐        ┌──┤         ├──┐
      3  │  │        │  │   ->   │  │         │  │
      4  └──┼────────┼──┘        └──┤         ├──┘
      5     └────────┘              └─────────┘

    """
    test "exceed valid period" do
      new_combination = Merge.merge(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 7200) and
        time_eq(new.end_time, 14400) and
        date_eq(new.from_date, ~D[2018-07-01]) and
        date_eq(new.through_date, ~D[2018-07-02])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 7200) and
        time_eq(new.end_time, 14400) and
        date_eq(new.from_date, ~D[2018-07-05]) and
        date_eq(new.through_date, ~D[2018-07-06])
      end)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 3600) and
        time_eq(new.end_time, 18000) and
        date_eq(new.from_date, ~D[2018-07-02]) and
        date_eq(new.through_date, ~D[2018-07-05])
      end)
    end


    @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}
    @time_block2 %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    @doc """

         1  2
      1  ┌──┐        ┌──┐
      2  │  │        │  │
      3  ├──┤   ->   │  │
      4  │  │        │  │
      5  └──┘        └──┘

    """
    test "overlap edge of time span" do
      new_combination = Merge.merge(@time_block1, @time_block2)

      assert Enum.any?(new_combination, fn new ->
        new.day_of_week == 1 and
        time_eq(new.start_time, 3600) and
        time_eq(new.end_time, 18000) and
        date_eq(new.from_date, ~D[2018-07-01]) and
        date_eq(new.through_date, ~D[2018-07-02])
      end)
    end
  end


  @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 14400,
    from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}
  @time_block2 %{day_of_week: 1, start_time: 3600, end_time: 14400,
    from_date: ~D[2018-07-03], through_date: ~D[2018-07-05]}

  @doc """
       1  2  3  4  5
    1  ┌─────┬─────┐        ┌───────────┐
    2  │     │     │   ->   │           │
    3  │     │     │        │           │
    4  └─────┴─────┘        └───────────┘

  """
  test "the same time span overlap edge of valid period" do
    new_combination = Merge.merge(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 14400) and
      date_eq(new.from_date, ~D[2018-07-01]) and
      date_eq(new.through_date, ~D[2018-07-05])
    end)
  end


  @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 18000,
    from_date: ~D[2018-07-01], through_date: ~D[2018-07-04]}
  @time_block2 %{day_of_week: 1, start_time: 7200, end_time: 14400,
    from_date: ~D[2018-07-02], through_date: ~D[2018-07-03]}

  @doc """

       1  2  3  4
    1  ┌────────┐        ┌──┬──┬──┐
    2  │  ┌──┐  │        │  │  │  │
    3  │  │  │  │   ->   │  │  │  │
    4  │  └──┘  │        │  │  │  │
    5  └────────┘        └──┴──┴──┘

  """
  test "cover entire block" do
    new_combination = Merge.merge(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 18000) and
      date_eq(new.from_date, ~D[2018-07-01]) and
      date_eq(new.through_date, ~D[2018-07-02])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 18000) and
      date_eq(new.from_date, ~D[2018-07-02]) and
      date_eq(new.through_date, ~D[2018-07-03])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 18000) and
      date_eq(new.from_date, ~D[2018-07-03]) and
      date_eq(new.through_date, ~D[2018-07-04])
    end)
  end


  @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 18000,
    from_date: ~D[2018-07-03], through_date: ~D[2018-07-05]}
  @time_block2 %{day_of_week: 1, start_time: 7200, end_time: 14400,
    from_date: nil, through_date: nil}

  @doc """
           3  4  5
    1      ┌─────┐                ┌─────┐
    2  ────┼─────┼────        ────┤     ├────
    3      │     │       ->       │     │
    4  ────┼─────┼────        ────┤     ├────
    5      └─────┘                └─────┘

  """
  test "infinite valid period with finite" do
    new_combination = Merge.merge(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 7200) and
      time_eq(new.end_time, 14400) and
      date_eq(valid_from(new.from_date), valid_from(nil)) and
      date_eq(valid_through(new.through_date), ~D[2018-07-03])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 18000) and
      date_eq(valid_from(new.from_date), ~D[2018-07-03]) and
      date_eq(valid_through(new.through_date), ~D[2018-07-05])
    end)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 7200) and
      time_eq(new.end_time, 14400) and
      date_eq(valid_from(new.from_date), ~D[2018-07-05]) and
      date_eq(valid_through(new.through_date), valid_through(nil))
    end)
  end


  @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 10800,
    from_date: nil, through_date: ~D[2018-07-03]}
  @time_block2 %{day_of_week: 1, start_time: 3600, end_time: 10800,
    from_date: ~D[2018-07-03], through_date: nil}

  @doc """
       1  2  3  4  5
    1  ──────┬──────        ─────────────
    2        │         ->
    3  ──────┴──────        ─────────────

  """
  test "infinite from_date with infinite through_date" do
    new_combination = Merge.merge(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 10800) and
      date_eq(valid_from(new.from_date), valid_from(nil)) and
      date_eq(valid_through(new.through_date), valid_through(nil))
    end)
  end


  @time_block1 %{day_of_week: 1, start_time: 3600, end_time: 14400,
    from_date: nil, through_date: nil}
  @time_block2 %{day_of_week: 1, start_time: 7200, end_time: 18000,
    from_date: nil, through_date: nil}

  @doc """

       1  2  3  4  5
    1  ─────────────        ─────────────
    2  ═════════════
    3                  ->
    4  ─────────────
    5  ═════════════        ─────────────

  """
  test "both valid periods are infinite" do
    new_combination = Merge.merge(@time_block1, @time_block2)

    assert Enum.any?(new_combination, fn new ->
      new.day_of_week == 1 and
      time_eq(new.start_time, 3600) and
      time_eq(new.end_time, 18000) and
      date_eq(valid_from(new.from_date), valid_from(nil)) and
      date_eq(valid_through(new.through_date), valid_through(nil))
    end)
  end


  ## Private

  defp time_eq(time0, time1) do
    time0 == time1
  end

  defp date_eq(datetime0, datetime1) do
    Date.compare(datetime0, datetime1) == :eq
  end
end
