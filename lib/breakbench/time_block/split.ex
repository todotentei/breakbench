defmodule Breakbench.TimeBlock.Split do
  @moduledoc false

  alias Breakbench.TimeBlock
  alias Breakbench.TimeBlock.DateRange

  import Breakbench.TimeBlock.DateRange, only:
    [to_from_date: 1, to_through_date: 1]


  def split(old_time_block, new_time_block) do
    try do
      # Return old_time_block, if nothing is splittable
      unless splittable?(old_time_block, new_time_block) do
        throw [old_time_block]
      end

      day_of_week = new_time_block.day_of_week

      {from_date, through_date} = DateRange.split(new_time_block, old_time_block)

      []
        |> append_on(Time.compare(
              new_time_block.start_time,
              old_time_block.start_time
            ) == :gt,
            TimeBlock.build(%{
              day_of_week: day_of_week,
              start_time: old_time_block.start_time,
              end_time: new_time_block.start_time,
              from_date: from_date,
              through_date: through_date
            }))
        |> append_on(Time.compare(
              new_time_block.end_time,
              old_time_block.end_time
            ) == :lt,
            TimeBlock.build(%{
              day_of_week: day_of_week,
              start_time: new_time_block.end_time,
              end_time: old_time_block.end_time,
              from_date: from_date,
              through_date: through_date
            }))
        |> append_on(Date.compare(
              to_from_date(new_time_block.from_date),
              to_from_date(old_time_block.from_date)
            ) == :gt,
            TimeBlock.build(%{
              day_of_week: day_of_week,
              start_time: old_time_block.start_time,
              end_time: old_time_block.end_time,
              from_date: old_time_block.from_date,
              through_date: new_time_block.from_date
            }))
        |> append_on(Date.compare(
              to_through_date(new_time_block.through_date),
              to_through_date(old_time_block.through_date)
            ) == :lt,
            TimeBlock.build(%{
              day_of_week: day_of_week,
              start_time: old_time_block.start_time,
              end_time: old_time_block.end_time,
              from_date: new_time_block.through_date,
              through_date: old_time_block.through_date
            }))
    catch
      hours -> hours
    end
  end

  def splittable?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if time spans overlap each other, exclude edges
      unless not(
        Time.compare(time_block0.start_time, time_block1.end_time) != :lt or
        Time.compare(time_block0.end_time, time_block1.start_time) != :gt
      ) do
        throw false
      end

      # Check if both date ranges overlap each other, include edge
      unless not(
        Date.compare(to_from_date(time_block0.from_date), to_through_date(time_block1.through_date)) != :lt or
        Date.compare(to_through_date(time_block0.through_date), to_from_date(time_block1.from_date)) != :gt
      ) do
        throw false
      end

      # Else, return true
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
