defmodule Breakbench.Field.DynamicPricing do
  @moduledoc false

  alias Breakbench.{Repo, Places, Timesheets}
  alias Breakbench.Places.Field
  alias Breakbench.Timesheets.TimeBlock
  alias Breakbench.TimeBlock.{
    Arrange, ArrangeState
  }

  import Ecto.Query


  def insert(%Field{} = field, price, new_time_block) do
    # Overlap time block
    dynamic_pricings = Places.overlap_field_dynamic_pricings(field, price, new_time_block)
    time_blocks = Enum.map dynamic_pricings, fn dynamic_pricing ->
      dynamic_pricing
        |> Ecto.assoc(:time_block)
        |> Repo.one
    end

    # Merge overlapped time_blocks with new_time_block
    uid = Arrange.merge(time_blocks, new_time_block)

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
          fch_attrs = %{time_block_id: time_block.id, field_id: field.id, price: price}
          Places.create_field_dynamic_pricing(fch_attrs)
        end
      end
    end
  end
end