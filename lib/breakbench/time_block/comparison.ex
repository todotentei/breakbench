defmodule Breakbench.TimeBlock.Comparison do
  @moduledoc false

  import Breakbench.TimeBlock.DateRange, only:
    [to_from_date: 1, to_through_date: 1]

  def is_overlap?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if both time spans overlap each other
      unless (
        Time.compare(time_block0.start_time, time_block1.start_time) == :eq and
        Time.compare(time_block0.end_time, time_block1.end_time) == :eq
      ) do
        throw false
      end

      # Then check if date range overlap each other
      unless (
        Date.compare(to_from_date(time_block0.from_date), to_from_date(time_block1.from_date)) == :eq and
        Date.compare(to_through_date(time_block0.through_date), to_through_date(time_block1.through_date)) == :eq
      ) do
        throw false
      end

      # Else, true
      true
    catch
      boolean -> boolean
    end
  end
end
