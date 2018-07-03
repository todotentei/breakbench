defmodule Breakbench.Timesheet.TimeSpan do
  @moduledoc false


  def combine(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    start_at = time_blocks
      |> Enum.min_by(&Map.get(&1, :start_at))
      |> Map.get(:start_at)

    end_at = time_blocks
      |> Enum.max_by(&Map.get(&1, :end_at))
      |> Map.get(:end_at)

    {start_at, end_at}
  end
end
