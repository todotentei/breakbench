defmodule Breakbench.Space.OpeningHour do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

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
    query = overlap_query(space, time_block)
    Repo.all(query)
  end


  ## Private

  defp overlap_query(space, tb) do
    from soh in Ecto.assoc(space, :opening_hours),
      inner_join: tbk in fragment("
        SELECT id FROM ?
      ", fn_overlap_time_blocks(^tb.day_of_week, ^tb.start_time, ^tb.end_time, ^tb.from_date, ^tb.through_date)),
        on: tbk.id == soh.time_block_id
  end
end
