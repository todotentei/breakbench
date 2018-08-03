defmodule Breakbench.TimeBlock.Comparison do
  @moduledoc false

  import Breakbench.TimeBlock.DateRange, only: [valid_from: 1, valid_through: 1]

  def is_overlap?(tb0, tb1) do
    try do
      # Valid only if both time blocks are on the same day
      unless tb0.day_of_week == tb1.day_of_week do
        throw false
      end

      # Check if both time spans overlap each other
      unless (
        tb0.start_time == tb1.start_time and
        tb0.end_time == tb1.end_time
      ) do
        throw false
      end

      # Then check if date range overlap each other
      unless (
        Date.compare(valid_from(tb0.from_date), valid_from(tb1.from_date)) == :eq and
        Date.compare(valid_through(tb0.through_date), valid_through(tb1.through_date)) == :eq
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
