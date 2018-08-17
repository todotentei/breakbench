defmodule Breakbench.Space.OpeningHour do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.{
    Facilities, Timesheets
  }

  alias Breakbench.Facilities.Space
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }


  def insert(%Space{} = space, time_block) do
    # Get current time blocks that overlap with time_block
    time_blocks = space
    |> overlap(time_block)
    |> Enum.map(fn opening_hour ->
      opening_hour
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
      # Delete all time_blocks from delete_state
      # -> this will automatically delete all related space_opening_hours
      ids = Enum.map(delete_state, &(&1.id))
      from(TimeBlock)
      |> where([tbk], tbk.id in ^ids)
      |> Repo.delete_all()

      # Insert new time_block
      for insert_attrs <- insert_state do
        with {:ok, time_block} <- Timesheets.create_time_block(insert_attrs) do
          Facilities.create_space_opening_hour(%{
            time_block_id: time_block.id,
            space_id: space.id
          })
        else
          _ -> Repo.rollback(:invalid_time_block)
        end
      end
    end
  end

  def overlap(%Space{} = space, time_block) do
    space
    |> Ecto.assoc(:opening_hours)
    |> join(:inner, [fch], tbk in fragment("SELECT id FROM overlap_time_blocks(?,?,?,?,?)",
      ^time_block.day_of_week, ^time_block.start_time, ^time_block.end_time,
      ^time_block.from_date, ^time_block.through_date), tbk.id == fch.time_block_id)
    |> Repo.all()
  end
end
