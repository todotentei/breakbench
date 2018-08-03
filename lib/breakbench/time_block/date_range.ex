defmodule Breakbench.TimeBlock.DateRange do
  @moduledoc false


  # Convert
  def valid_from(datetime) do
    datetime || ~D[0000-01-01]
  end

  def valid_through(datetime) do
    datetime || ~D[9999-12-31]
  end


  # merge
  def merge(tb0, tb1) do
    time_blocks = [tb0, tb1]

    touch1? = tb0.start_time == tb1.start_time
    touch2? = tb0.end_time == tb1.end_time

    cond do
      touch1? and touch2? ->
        from_date = time_blocks
          |> Enum.min_by(&valid_from(&1.from_date))
          |> Map.get(:from_date)

        through_date = time_blocks
          |> Enum.max_by(&valid_through(&1.through_date))
          |> Map.get(:through_date)

        {from_date, through_date}

      touch1? != touch2? ->
        tb0_diff = tb0.end_time - tb0.start_time
        tb1_diff = tb1.end_time - tb0.start_time

        cond do
          tb0_diff > tb1_diff -> {tb0.from_date, tb0.through_date}
          true -> {tb1.from_date, tb1.through_date}
        end

      not(touch1? || touch2?) ->
        from_date = time_blocks
          |> Enum.max_by(&valid_from(&1.from_date))
          |> Map.get(:from_date)

        through_date = time_blocks
          |> Enum.min_by(&valid_through(&1.through_date))
          |> Map.get(:through_date)

        {from_date, through_date}
    end
  end


  # Split
  def split(tb0, tb1) do
    time_blocks = [tb0, tb1]

    from_date = time_blocks
      |> Enum.max_by(&valid_from(&1.from_date))
      |> Map.get(:from_date)

    through_date = time_blocks
      |> Enum.min_by(&valid_through(&1.through_date))
      |> Map.get(:through_date)

    {from_date, through_date}
  end
end
