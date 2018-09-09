defmodule Breakbench.TimeBlock.Split do
  @moduledoc false

  alias Breakbench.TimeBlock
  alias Breakbench.TimeBlock.DateRange

  import Breakbench.TimeBlock.DateRange, only:
    [valid_from: 1, valid_through: 1]


  def split(old_time_block, new_time_block) do
    try do
      # Return old_time_block, if nothing is splittable
      unless splittable?(old_time_block, new_time_block) do
        throw [old_time_block]
      end

      day_of_week = new_time_block.day_of_week

      {from_date, through_date} = DateRange.split(new_time_block, old_time_block)

      []
      |> append_on(new_time_block.start_time > old_time_block.start_time,
          TimeBlock.build(%{
            day_of_week: day_of_week,
            start_time: old_time_block.start_time,
            end_time: new_time_block.start_time,
            from_date: from_date,
            through_date: through_date
          }))
      |> append_on(new_time_block.end_time < old_time_block.end_time,
          TimeBlock.build(%{
            day_of_week: day_of_week,
            start_time: new_time_block.end_time,
            end_time: old_time_block.end_time,
            from_date: from_date,
            through_date: through_date
          }))
      |> append_on(Date.compare(
            valid_from(new_time_block.from_date),
            valid_from(old_time_block.from_date)
          ) == :gt,
          TimeBlock.build(%{
            day_of_week: day_of_week,
            start_time: old_time_block.start_time,
            end_time: old_time_block.end_time,
            from_date: old_time_block.from_date,
            through_date: new_time_block.from_date
          }))
      |> append_on(Date.compare(
            valid_through(new_time_block.through_date),
            valid_through(old_time_block.through_date)
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
        time_block0.start_time >= time_block1.end_time or
        time_block0.end_time <= time_block1.start_time
      ) do
        throw false
      end

      # Check if both date ranges overlap each other, include edge
      unless not(
        Date.compare(valid_from(time_block0.from_date), valid_through(time_block1.through_date)) != :lt or
        Date.compare(valid_through(time_block0.through_date), valid_from(time_block1.from_date)) != :gt
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
