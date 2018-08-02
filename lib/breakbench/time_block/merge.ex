defmodule Breakbench.TimeBlock.Merge do
  @moduledoc false

  alias Breakbench.TimeBlock
  alias Breakbench.TimeBlock.{
    TimeRange, DateRange
  }

  import Breakbench.TimeBlock.DateRange, only: [
    to_from_date: 1, to_through_date: 1
  ]


  def merge(old_time_block, new_time_block) do
    try do
      time_blocks = [new_time_block, old_time_block]

      # Return, if both aren't mergeable
      unless mergeable?(old_time_block, old_time_block) do
        throw time_blocks
      end

      day_of_week = new_time_block.day_of_week

      {from_date, through_date} = DateRange.merge(new_time_block, old_time_block)
      {start_time, end_time} = TimeRange.merge(new_time_block, old_time_block)

      default = [
        TimeBlock.build(%{
          day_of_week: day_of_week,
          start_time: start_time,
          end_time: end_time,
          from_date: from_date,
          through_date: through_date
        })
      ]

      # Break exceed into small pieces
      Enum.reduce(time_blocks, default, fn time_block, accumulator ->
        accumulator
          |> append_on(Date.compare(
                to_from_date(from_date),
                to_from_date(time_block.from_date)
              ) == :gt,
              TimeBlock.build(%{
                day_of_week: day_of_week,
                start_time: time_block.start_time,
                end_time: time_block.end_time,
                from_date: time_block.from_date,
                through_date: from_date
              }))
          |> append_on(Date.compare(
                to_through_date(through_date),
                to_through_date(time_block.through_date)
              ) == :lt,
              TimeBlock.build(%{
                day_of_week: day_of_week,
                start_time: time_block.start_time,
                end_time: time_block.end_time,
                from_date: through_date,
                through_date: time_block.through_date
              }))
      end)
    catch
      hours -> hours
    end
  end

  def mergeable?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if time spans overlap each other, include edges
      unless not(
        Time.compare(time_block0.start_time, time_block1.end_time) == :gt or
        Time.compare(time_block0.end_time, time_block1.start_time) == :lt
      ) do
        throw false
      end

      # Check if both date ranges overlap each other, include edge
      unless not(
        Date.compare(to_from_date(time_block0.from_date), to_through_date(time_block1.through_date)) == :gt or
        Date.compare(to_through_date(time_block0.through_date), to_from_date(time_block1.from_date)) == :lt
      ) do
        throw false
      end

      # If one of the date range edges overlap each other and both of the
      # time span edges aren't overlapping -> false
      if not(
        Time.compare(time_block0.start_time, time_block1.start_time) == :eq and
        Time.compare(time_block0.end_time, time_block1.end_time) == :eq
      ) and (
        Date.compare(to_from_date(time_block0.from_date), to_through_date(time_block1.through_date)) == :eq or
        Date.compare(to_through_date(time_block0.through_date), to_from_date(time_block1.from_date)) == :eq
      ) do
        throw false
      end

      # Else return true
      true
    catch
      boolean -> boolean
    end
  end


  ## Private

  defp append_on(list, condition, elements) do
    if condition do
      List.wrap(elements) ++ list
    else
      list
    end
  end
end
