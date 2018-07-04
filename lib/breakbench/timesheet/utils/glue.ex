defmodule Breakbench.TimeBlock.Glue do
  @moduledoc false

  alias Breakbench.TimeBlock
  alias Breakbench.TimeBlock.{Arrange, Comparison}


  @doc """
  Glue all broken pieces together
  """
  def paste(time_blocks, state: uid) do
    try do
      for time_block0 <- time_blocks do
        # Paste time_block0 with other time_blocks, except itself
        for time_block1 <- time_blocks -- [time_block0] do
          if TimeBlock.combinable?(time_block0, time_block1) do
            combination = TimeBlock.combine(time_block0, time_block1)
            # Remove old time_blocks and add the new combied to list
            time_blocks = time_blocks -- [time_block0, time_block1]
            time_blocks = time_blocks ++ combination
            # Break the current loop and start a new one
            throw(time_blocks)
          end
        end

        # States
        delete_state = Arrange.lookup_state(uid, :delete)
        insert_state = Arrange.lookup_state(uid, :insert)

        # If no new combination override the old one, then keep it
        # Else, replace it with the new combined time_block
        if Enum.any?(delete_state, &Comparison.is_intersect?(&1, time_block0)) do
          # Remove overlapped time_block0 from delete state
          updated_delete_list =
            Enum.filter(delete_state, fn time_block ->
              !Enum.any?(List.wrap(time_block0),
                &Comparison.is_intersect?(&1, time_block))
            end)

          # If a new combined time_block is deplicated with an old time_block.
          # Keep the old time_block by remove it from delete queue, as it makes no
          # different of weather replace it or not.
          Arrange.update_state(uid, :delete, updated_delete_list)
        else
          # Insert time_block0 to insert state
          updated_insert_list = insert_state ++ List.wrap(time_block0)

          # Put time_block0 to insert queue, as it has nothing else to paste with
          Arrange.update_state(uid, :insert, updated_insert_list)
        end
      end
    catch new_time_blocks ->
      # Re-paste it
      paste(new_time_blocks, state: uid)
    end
  end
end
