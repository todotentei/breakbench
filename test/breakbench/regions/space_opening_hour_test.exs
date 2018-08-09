defmodule Breakbench.SpaceOpeningHourTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Regions, Timesheets}
  alias Breakbench.Regions.SpaceOpeningHour


  describe "space_opening_hours validation" do
    setup do
      space = insert(:space)

      time_block = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 7200,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-02])
      insert(:space_opening_hour, space: space, time_block: time_block)

      {:ok, space: space}
    end


    @valid_time_block %{day_of_week: 1, start_time: 7200, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "unique time_block returns space_opening_hour", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      sop_attrs = %{time_block_id: time_block.id, space_id: context[:space].id}

      assert {:ok, %SpaceOpeningHour{}} = Regions.create_space_opening_hour(sop_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "non unique time_block raises postgrex error", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      sop_attrs = %{time_block_id: time_block.id, space_id: context[:space].id}

      assert_raise Postgrex.Error, fn -> Regions.create_space_opening_hour(sop_attrs) end
    end
  end


  describe "space_opening_hours" do
    alias Breakbench.Space.OpeningHour

    setup do
      space = insert(:space)

      time_block1 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 10800,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-03])
      time_block2 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 18000,
        from_date: ~D[2018-07-03], through_date: ~D[2018-07-05])

      insert(:space_opening_hour, space: space, time_block: time_block1)
      insert(:space_opening_hour, space: space, time_block: time_block2)

      {:ok, space: space, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}

    test "insert/2 merges all overlappings", context do
      OpeningHour.insert(context[:space], @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Regions.get_space_opening_hour!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Regions.get_space_opening_hour!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      space_opening_hours = Repo.preload(Regions.list_space_opening_hours(), :time_block)
      assert Enum.all? space_opening_hours, fn %{time_block: time_block} ->
        time_block.day_of_week == 1 and
        time_eq(time_block.start_time, 3600) and
        time_eq(time_block.end_time, 18000) and
        date_eq(time_block.from_date, ~D[2018-07-01]) and
        date_eq(time_block.through_date, ~D[2018-07-05])
      end
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
