defmodule Breakbench.Field.DynamicPricingTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Places, Timesheets}
  alias Breakbench.Places.FieldDynamicPricing


  describe "field_dynamic_pricings validation" do
    setup do
      field = insert(:field)

      time_block = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[02:00:00],
        valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00])
      insert(:field_dynamic_pricing, field: field, time_block: time_block, price: 1000)

      {:ok, field: field}
    end


    @valid_time_block %{day_of_week: 1, start_at: ~T[02:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}

    test "unique time_block returns field_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@valid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_id: context[:field].id, price: 1000}

      assert {:ok, %FieldDynamicPricing{}} = Places.create_field_dynamic_pricing(fdp_attrs)
    end


    @invalid_time_block %{day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-02 00:00:00]}

    test "not unique time_block with different price returns field_dynamic_pricing", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_id: context[:field].id, price: 2000}

      assert {:ok, %FieldDynamicPricing{}} = Places.create_field_dynamic_pricing(fdp_attrs)
    end

    test "not unique time_block raises postgrex error", context do
      {:ok, time_block} = Timesheets.create_time_block(@invalid_time_block)
      fdp_attrs = %{time_block_id: time_block.id, field_id: context[:field].id, price: 1000}

      assert_raise Postgrex.Error, fn -> Places.create_field_dynamic_pricing(fdp_attrs) end
    end
  end


  describe "field_dynamic_pricings arrangement" do
    alias Breakbench.Field.DynamicPricing

    setup do
      field = insert(:field)

      time_block1 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[03:00:00],
        valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00])
      time_block2 = insert(:time_block, day_of_week: 1, start_at: ~T[01:00:00], end_at: ~T[05:00:00],
        valid_from: ~N[2018-07-03 00:00:00], valid_through: ~N[2018-07-05 00:00:00])

      insert(:field_dynamic_pricing, field: field, time_block: time_block1)
      insert(:field_dynamic_pricing, field: field, time_block: time_block2)

      {:ok, field: field, time_block1: time_block1, time_block2: time_block2}
    end


    @new_time_block %{day_of_week: 1, start_at: ~T[03:00:00], end_at: ~T[05:00:00],
      valid_from: ~N[2018-07-01 00:00:00], valid_through: ~N[2018-07-03 00:00:00]}

    test "insert/2 merges all intersected time_blocks", context do
      DynamicPricing.insert(context[:field], 1000, @new_time_block)

      assert_raise Ecto.NoResultsError, fn -> Places.get_field_dynamic_pricing!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Places.get_field_dynamic_pricing!(context[:time_block2].id) end

      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block1].id) end
      assert_raise Ecto.NoResultsError, fn -> Timesheets.get_time_block!(context[:time_block2].id) end

      field_dynamic_pricings = Places.list_field_dynamic_pricings()
        |> Repo.preload(:time_block)
      assert Enum.all? field_dynamic_pricings, fn %{time_block: time_block} ->
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
