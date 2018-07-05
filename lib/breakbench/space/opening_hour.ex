defmodule Breakbench.Space.OpeningHour do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.{Places, Timesheets}
  alias Breakbench.Places.Space
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.Arrange

  import Ecto.Query


  def insert(%Space{} = space, new_time_block) do
    # Get current time blocks that intersect with new_time_block
    opening_hours = Places.intersect_space_opening_hours(space, new_time_block)
    time_blocks = Enum.map(opening_hours, fn opening_hour ->
      opening_hour
        |> Ecto.assoc(:time_block)
        |> Repo.one
    end)

    # Merge intersected time_blocks with new_time_block
    uid = Arrange.merge(time_blocks, new_time_block)

    insert_state = Arrange.lookup_state(uid, :insert)
    delete_state = Arrange.lookup_state(uid, :delete)

    # Make sure state is deleted after completion
    Arrange.delete_state(uid)

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
          Places.create_space_opening_hour(sop_attrs)
        end
      end
    end
  end
end
