defmodule Breakbench.Timesheet.Comparison do
  @moduledoc false

  import Breakbench.Timesheet.ValidPeriod, only:
    [to_valid_from: 1, to_valid_through: 1]

  def is_intersect?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if both time spans intersect each other
      ts_condition1 = Time.compare(time_block0.start_at, time_block1.start_at) == :eq
      ts_condition2 = Time.compare(time_block0.end_at, time_block1.end_at) == :eq
      unless ts_condition1 and ts_condition2 do
        throw false
      end

      # Then check for valid period intersection
      vp_condition1 = NaiveDateTime.compare(to_valid_from(time_block0.valid_from),
        to_valid_from(time_block1.valid_from)) == :eq
      vp_condition2 = NaiveDateTime.compare(to_valid_through(time_block0.valid_through),
        to_valid_through(time_block1.valid_through)) == :eq
      unless vp_condition1 and vp_condition2 do
        throw false
      end

      # Else, true
      true
    catch
      boolean -> boolean
    end
  end
end
