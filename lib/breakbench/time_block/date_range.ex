defmodule Breakbench.TimeBlock.DateRange do
  @moduledoc false


  # Convert
  def to_from_date(datetime) do
    datetime || ~D[0000-01-01]
  end

  def to_through_date(datetime) do
    datetime || ~D[9999-12-31]
  end


  # merge
  def merge(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    ts_edge_1_overlap? = Time.compare(time_block0.start_time, time_block1.start_time) == :eq
    ts_edge_2_overlap? = Time.compare(time_block0.end_time, time_block1.end_time) == :eq

    cond do
      ts_edge_1_overlap? and ts_edge_2_overlap? ->
        from_date = time_blocks
          |> Enum.min_by(&to_from_date(&1.from_date))
          |> Map.get(:from_date)

        through_date = time_blocks
          |> Enum.max_by(&to_through_date(&1.through_date))
          |> Map.get(:through_date)

        {from_date, through_date}

      ts_edge_1_overlap? != ts_edge_2_overlap? ->
        tb0_diff = Time.diff(time_block0.end_time, time_block0.start_time)
        tb1_diff = Time.diff(time_block1.end_time, time_block0.start_time)

        cond do
          tb0_diff > tb1_diff ->
            {time_block0.from_date, time_block0.through_date}
          true ->
            {time_block1.from_date, time_block1.through_date}
        end

      not(ts_edge_1_overlap? || ts_edge_2_overlap?) ->
        from_date = time_blocks
          |> Enum.max_by(&to_from_date(&1.from_date))
          |> Map.get(:from_date)

        through_date = time_blocks
          |> Enum.min_by(&to_through_date(&1.through_date))
          |> Map.get(:through_date)

        {from_date, through_date}
    end
  end


  # Split
  def split(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    from_date = time_blocks
      |> Enum.max_by(&to_from_date(&1.from_date))
      |> Map.get(:from_date)

    through_date = time_blocks
      |> Enum.min_by(&to_through_date(&1.through_date))
      |> Map.get(:through_date)

    {from_date, through_date}
  end
end
