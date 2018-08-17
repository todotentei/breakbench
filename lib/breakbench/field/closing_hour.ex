defmodule Breakbench.Field.ClosingHour do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.{
    Facilities, Timesheets
  }

  alias Breakbench.Facilities.Field
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }


  def insert(%Field{} = field, time_block) do
    # Overlap time block
    time_blocks = field
    |> overlap(time_block)
    |> Enum.map(fn closing_hour ->
      closing_hour
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
      Enum.each insert_state, fn insert_attrs ->
        with {:ok, time_block} <- Timesheets.create_time_block(insert_attrs) do
          Facilities.create_field_closing_hour(%{
            time_block_id: time_block.id,
            field_id: field.id
          })
        else
          _ -> Repo.rollback(:invalid_time_block)
        end
      end
    end
  end

  def overlap(%Field{} = field, time_block) do
    field
    |> Ecto.assoc(:closing_hours)
    |> join(:inner, [fch], tbk in fragment("SELECT id FROM overlap_time_blocks(?,?,?,?,?)",
      ^time_block.day_of_week, ^time_block.start_time, ^time_block.end_time,
      ^time_block.from_date, ^time_block.through_date), tbk.id == fch.time_block_id)
    |> Repo.all()
  end
end
