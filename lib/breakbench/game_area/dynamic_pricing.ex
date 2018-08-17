defmodule Breakbench.GameArea.DynamicPricing do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.{
    Facilities, Timesheets
  }

  alias Breakbench.Facilities.GameAreaMode
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }


  def insert(%GameAreaMode{} = game_area_mode, price, time_block) do
    # Overlap time block
    time_blocks = game_area_mode
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
            game_area_mode_id: game_area_mode.id,
            price: price
          })
        else
          _ -> Repo.rollback(:invalid_time_block)
        end
      end)
    end
  end

  def overlap(%GameAreaMode{} = game_area_mode, price, time_block) do
    game_area_mode
    |> Ecto.assoc(:dynamic_pricings)
    |> where(price: ^price)
    |> join(:inner, [fdp], tbk in fragment("SELECT id FROM overlap_time_blocks(?,?,?,?,?)",
      ^time_block.day_of_week, ^time_block.start_time, ^time_block.end_time,
      ^time_block.from_date, ^time_block.through_date), tbk.id == fdp.time_block_id)
    |> Repo.all()
  end
end