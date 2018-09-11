defmodule Breakbench.GameArea.ClosingHour do
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


  def insert(%GameArea{} = game_area, time_block) do
    # Overlap time block
    time_blocks = game_area
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
          Facilities.create_game_area_closing_hour(%{
            time_block_id: time_block.id,
            game_area_id: game_area.id
          })
        else
          _ -> Repo.rollback(:invalid_time_block)
        end
      end
    end
  end

  def overlap(%GameArea{} = game_area, time_block) do
    query = overlap_query(game_area, time_block)
    Repo.all(query)
  end


  ## Private

  defp overlap_query(game_area, tb) do
    from gch in Ecto.assoc(game_area, :closing_hours),
      inner_join: tbk in fragment("
        SELECT id FROM ?
      ", fn_overlap_time_blocks(^tb.day_of_week, ^tb.start_time, ^tb.end_time, ^tb.from_date, ^tb.through_date)),
        on: tbk.id == gch.time_block_id
  end
end
