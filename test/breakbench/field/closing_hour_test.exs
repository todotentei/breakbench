defmodule Breakbench.Field.ClosingHourTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Places, Timesheets}
  alias Breakbench.Places.FieldClosingHour


  describe "field_closing_hours validation" do
    setup do
      field = insert(:field)

      time_block = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 7200,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-02])
      insert(:field_closing_hour, field: field, time_block: time_block)

      {:ok, field: field}
    end


    @valid_time_block %{day_of_week: 1, start_time: 7200, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "unique time_block returns field_closing_hour", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      fch_attrs = %{time_block_id: time_block.id, field_id: context[:field].id}

      assert {:ok, %FieldClosingHour{}} = Places.create_field_closing_hour(fch_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

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

      time_block1 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 10800,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-03])
      time_block2 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 18000,
        from_date: ~D[2018-07-03], through_date: ~D[2018-07-05])

      insert(:field_closing_hour, field: field, time_block: time_block1)
      insert(:field_closing_hour, field: field, time_block: time_block2)

      {:ok, field: field, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}

    test "insert/2 merges all overlapped time_blocks", context do
      ClosingHour.insert(context[:field], @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Places.get_field_closing_hour!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Places.get_field_closing_hour!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      field_closing_hours = Places.list_field_closing_hours()
        |> Repo.preload(:time_block)
      assert Enum.all? field_closing_hours, fn %{time_block: time_block} ->
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
