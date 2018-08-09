defmodule Breakbench.Space.OpeningHour do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.{Regions, Timesheets}
  alias Breakbench.Regions.Space
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }

  import Ecto.Query


  def insert(%Space{} = space, new_time_block) do
    # Get current time blocks that overlap with new_time_block
    opening_hours = Regions.overlap_space_opening_hours(space, new_time_block)
    time_blocks = Enum.map(opening_hours, fn opening_hour ->
      opening_hour
        |> Ecto.assoc(:time_block)
        |> Repo.one
    end)

    # Merge overlapped time_blocks with new_time_block
    uid = Arrange.merge(time_blocks, new_time_block)

    insert_state = ArrangeState.lookup_state(uid, :insert)
    delete_state = ArrangeState.lookup_state(uid, :delete)

    # Make sure state is deleted after completion
    ArrangeState.delete_state(uid)

    Repo.transaction fn ->
      # Delete all time_blocks from delete_state
      # -> this will automatically delete all related space_opening_hours
      ids = Enum.map(delete_state, &(&1.id))
      from(TimeBlock)
        |> where([tbk], tbk.id in ^ids)
        |> Repo.delete_all()

      # Insert new time_block
      for insert_attrs <- insert_state do
        with {:ok, time_block} = Timesheets.create_time_block(insert_attrs) do
          sop_attrs = %{time_block_id: time_block.id, space_id: space.id}
          Regions.create_space_opening_hour(sop_attrs)
        end
      end
    end
  end
end
