defmodule Breakbench.TimeBlock.Merge do
  @moduledoc false

  alias Breakbench.TimeBlock
  alias Breakbench.TimeBlock.{
    TimeRange, DateRange
  }

  import Breakbench.TimeBlock.DateRange, only: [
    valid_from: 1, valid_through: 1
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
                valid_from(from_date),
                valid_from(time_block.from_date)
              ) == :gt,
              TimeBlock.build(%{
                day_of_week: day_of_week,
                start_time: time_block.start_time,
                end_time: time_block.end_time,
                from_date: time_block.from_date,
                through_date: from_date
              }))
          |> append_on(Date.compare(
                valid_through(through_date),
                valid_through(time_block.through_date)
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

  def mergeable?(tb0, tb1) do
    try do
      # Valid only if both time blocks are on the same day
      unless tb0.day_of_week == tb1.day_of_week do
        throw false
      end

      # Check if time spans overlap each other, include edges
      unless not(
        tb0.start_time > tb1.end_time or
        tb0.end_time < tb1.start_time
      ) do
        throw false
      end

      # Check if both date ranges overlap each other, include edge
      unless not(
        Date.compare(valid_from(tb0.from_date), valid_through(tb1.through_date)) == :gt or
        Date.compare(valid_through(tb0.through_date), valid_from(tb1.from_date)) == :lt
      ) do
        throw false
      end

      # If one of the date range edges overlap each other and both of the
      # time span edges aren't overlapping -> false
      if not(
        tb0.start_time == tb1.start_time and
        tb0.end_time == tb1.end_time
      ) and (
        Date.compare(valid_from(tb0.from_date), valid_through(tb1.through_date)) == :eq or
        Date.compare(valid_through(tb0.through_date), valid_from(tb1.from_date)) == :eq
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
