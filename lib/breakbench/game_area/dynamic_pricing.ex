defmodule Breakbench.GameArea.DynamicPricing do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

  alias Breakbench.Repo

  alias Breakbench.{
    Facilities, Timesheets
  }

  alias Breakbench.Facilities.GameArea
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }


  def insert(%GameArea{} = game_area, price, time_block) do
    # Overlap time block
    time_blocks = game_area
    |> overlap(price, time_block)
    |> Enum.map(fn dynamic_pricing ->
      dynamic_pricing
      |> Ecto.assoc(:time_block)
      |> Repo.one
    end)

    # Merge overlapped time_blocks with time_block
    uid = Arrange.merge(time_blocks, time_block)

    insert_state = ArrangeState.lookup_state(uid, :insert)
    delete_state = ArrangeState.lookup_state(uid, :delete)

    # Make sure state is deleted after completion
    ArrangeState.delete_state(uid)

    Repo.transaction fn ->
      # Delete all overlapped time_blocks
      ids = Enum.map(delete_state, &(&1.id))
      from(TimeBlock)
      |> where([tbk], tbk.id in ^ids)
      |> Repo.delete_all()

      # Insert new time_block
      Enum.each(insert_state, fn insert_attrs ->
        with {:ok, time_block} <- Timesheets.create_time_block(insert_attrs) do
          Facilities.create_game_area_dynamic_pricing(%{
            time_block_id: time_block.id,
            game_area_id: game_area.id,
            price: price
          })
        else
          _ -> Repo.rollback(:invalid_time_block)
        end
      end)
    end
  end

  def overlap(%GameArea{} = game_area, price, time_block) do
    query = overlap_query(game_area, price, time_block)
    Repo.all(query)
  end


  ## Private

  defp overlap_query(game_area, price, tb) do
    from gdp in Ecto.assoc(game_area, :dynamic_pricings),
      inner_join: tbk in fragment("
        SELECT id FROM ?
      ", fn_overlap_time_blocks(^tb.day_of_week, ^tb.start_time, ^tb.end_time, ^tb.from_date, ^tb.through_date)),
        on: tbk.id == gdp.time_block_id,
      where: gdp.price == ^price
  end
end
