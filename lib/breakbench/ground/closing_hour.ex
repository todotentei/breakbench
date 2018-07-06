defmodule Breakbench.Ground.ClosingHour do
  @moduledoc false

  alias Breakbench.{Repo, Places, Timesheets}
  alias Breakbench.Places.Ground
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.Arrange

  import Ecto.Query


  def insert(%Ground{} = ground, new_time_block) do
    # Intersect time blocks
    closing_hours = Places.intersect_ground_closing_hours(ground, new_time_block)
    time_blocks = Enum.map closing_hours, fn closing_hour ->
      closing_hour
        |> Ecto.assoc(:time_block)
        |> Repo.one
    end

    # Merge intersected time_blocks with new_time_block
    uid = Arrange.merge(time_blocks, new_time_block)

    insert_state = Arrange.lookup_state(uid, :insert)
    delete_state = Arrange.lookup_state(uid, :delete)

    # Make sure state is deleted after completion
    Arrange.delete_state(uid)

    Repo.transaction fn ->
      # Delete all intersected time_blocks
      ids = Enum.map(delete_state, &(&1.id))
      from(TimeBlock)
        |> where([tbk], tbk.id in ^ids)
        |> Repo.delete_all()

      # Insert new time_block
      Enum.each insert_state, fn insert_attrs ->
        with {:ok, time_block} <- Timesheets.create_time_block(insert_attrs) do
          sop_attrs = %{time_block_id: time_block.id, ground_id: ground.id}
          Places.create_ground_closing_hour(sop_attrs)
        end
      end
    end
  end
end
