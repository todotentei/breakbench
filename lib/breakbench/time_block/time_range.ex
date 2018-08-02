defmodule Breakbench.TimeBlock.TimeRange do
  @moduledoc false


  def merge(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    start_time = time_blocks
      |> Enum.min_by(&Map.get(&1, :start_time))
      |> Map.get(:start_time)

    end_time = time_blocks
      |> Enum.max_by(&Map.get(&1, :end_time))
      |> Map.get(:end_time)

    {start_time, end_time}
  end
end
