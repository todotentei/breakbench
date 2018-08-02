defmodule Breakbench.TimeBlock.Arrange do
  @moduledoc false

  alias Breakbench.TimeBlock.{
    Glue, Merge, Split, ArrangeState
  }


  @doc """
  merge a new_time_block with a set of time_blocks.
  Then glue all the broken pieces together.

  -> state uid
  """
  def merge(time_blocks, new_time_block) do
    uid = ArrangeState.new_state(time_blocks)

    time_blocks
      |> Enum.reduce([], & &2 ++ Merge.merge(&1, new_time_block))
      |> Glue.paste(state: uid)

    # Returns state id
    uid
  end

  @doc """
  Split target_time_block from related set of time_blocks.
  The same as merge, then glue all the broken pieces together.

  -> state uid
  """
  def split(time_blocks, target_time_block) do
    uid = ArrangeState.new_state(time_blocks)

    time_blocks
      |> Enum.reduce([], & &2 ++ Split.split(&1, target_time_block))
      |> Glue.paste(uid)

    # Returns state id
    uid
  end
end
