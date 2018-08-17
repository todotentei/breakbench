defmodule Breakbench.Facilities.FieldDynamicPricingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Facilities, Timesheets}
  alias Breakbench.Facilities.FieldDynamicPricing


  describe "field_dynamic_pricings validation" do
    setup do
      field_game_mode = insert(:field_game_mode)

      time_block = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 7200,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-02])
      insert(:field_dynamic_pricing, field_game_mode: field_game_mode, time_block: time_block, price: 1000)

      {:ok, field_game_mode: field_game_mode}
    end


    @valid_time_block %{day_of_week: 1, start_time: 7200, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "unique time_block returns field_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_game_mode_id: context[:field_game_mode].id, price: 1000}

      assert {:ok, %FieldDynamicPricing{}} = Facilities.create_field_dynamic_pricing(fdp_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "not unique time_block with different price returns field_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_game_mode_id: context[:field_game_mode].id, price: 2000}

      assert {:ok, %FieldDynamicPricing{}} = Facilities.create_field_dynamic_pricing(fdp_attrs)
    end

    test "not unique time_block raises postgrex error", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_game_mode_id: context[:field_game_mode].id, price: 1000}

      assert_raise Postgrex.Error, fn -> Facilities.create_field_dynamic_pricing(fdp_attrs) end
    end
  end


  describe "field_dynamic_pricings arrangement" do
    alias Breakbench.Field.DynamicPricing

    setup do
      field_game_mode = insert(:field_game_mode)

      time_block1 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 10800,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-03])
      time_block2 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 18000,
        from_date: ~D[2018-07-03], through_date: ~D[2018-07-05])

      insert(:field_dynamic_pricing, field_game_mode: field_game_mode, time_block: time_block1)
      insert(:field_dynamic_pricing, field_game_mode: field_game_mode, time_block: time_block2)

      {:ok, field_game_mode: field_game_mode, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}

    test "insert/2 merges all overlapped time_blocks", context do
      DynamicPricing.insert(context[:field_game_mode], 1000, @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Facilities.get_field_dynamic_pricing!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Facilities.get_field_dynamic_pricing!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      field_dynamic_pricings = Facilities.list_field_dynamic_pricings()
        |> Repo.preload(:time_block)
      assert Enum.all? field_dynamic_pricings, fn %{time_block: time_block} ->
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
