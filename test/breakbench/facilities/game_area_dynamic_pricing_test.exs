defmodule Breakbench.Facilities.GameAreaDynamicPricingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Facilities, Timesheets}
  alias Breakbench.Facilities.GameAreaDynamicPricing


  describe "game_area_dynamic_pricings validation" do
    setup do
      game_area = insert(:game_area)

      time_block = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 7200,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-02])
      insert(:game_area_dynamic_pricing, game_area: game_area, time_block: time_block, price: 1000)

      {:ok, game_area: game_area}
    end


    @valid_time_block %{day_of_week: 1, start_time: 7200, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "unique time_block returns game_area_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, game_area_id: context[:game_area].id, price: 1000}

      assert {:ok, %GameAreaDynamicPricing{}} = Facilities.create_game_area_dynamic_pricing(fdp_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_time: 3600, end_time: 10800,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-02]}

    test "not unique time_block with different price returns game_area_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, game_area_id: context[:game_area].id, price: 2000}

      assert {:ok, %GameAreaDynamicPricing{}} = Facilities.create_game_area_dynamic_pricing(fdp_attrs)
    end

    test "not unique time_block raises postgrex error", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, game_area_id: context[:game_area].id, price: 1000}

      assert_raise Postgrex.Error, fn -> Facilities.create_game_area_dynamic_pricing(fdp_attrs) end
    end
  end


  describe "game_area_dynamic_pricings arrangement" do
    alias Breakbench.GameArea.DynamicPricing

    setup do
      game_area = insert(:game_area)

      time_block1 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 10800,
        from_date: ~D[2018-07-01], through_date: ~D[2018-07-03])
      time_block2 = insert(:time_block, day_of_week: 1, start_time: 3600, end_time: 18000,
        from_date: ~D[2018-07-03], through_date: ~D[2018-07-05])

      insert(:game_area_dynamic_pricing, game_area: game_area, time_block: time_block1)
      insert(:game_area_dynamic_pricing, game_area: game_area, time_block: time_block2)

      {:ok, game_area: game_area, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_time: 10800, end_time: 18000,
      from_date: ~D[2018-07-01], through_date: ~D[2018-07-03]}

    test "insert/2 merges all overlapped time_blocks", context do
      DynamicPricing.insert(context[:game_area], 1000, @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Facilities.get_game_area_dynamic_pricing!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Facilities.get_game_area_dynamic_pricing!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      game_area_dynamic_pricings = Facilities.list_game_area_dynamic_pricings()
      |> Repo.preload(:time_block)

      assert Enum.all? game_area_dynamic_pricings, fn %{time_block: time_block} ->
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
