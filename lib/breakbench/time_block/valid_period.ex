defmodule Breakbench.TimeBlock.ValidPeriod do
  @moduledoc false


  # Convert
  def to_valid_from(datetime) do
    datetime || ~N[0000-01-01 00:00:00]
  end

  def to_valid_through(datetime) do
    datetime || ~N[9999-12-31 23:59:59]
  end


  # merge
  def merge(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    ts_edge_1_overlap? = Time.compare(time_block0.start_at, time_block1.start_at) == :eq
    ts_edge_2_overlap? = Time.compare(time_block0.end_at, time_block1.end_at) == :eq

    cond do
      ts_edge_1_overlap? and ts_edge_2_overlap? ->
        valid_from = time_blocks
          |> Enum.min_by(&to_valid_from(&1.valid_from))
          |> Map.get(:valid_from)

        valid_through = time_blocks
          |> Enum.max_by(&to_valid_through(&1.valid_through))
          |> Map.get(:valid_through)

        {valid_from, valid_through}

      ts_edge_1_overlap? != ts_edge_2_overlap? ->
        tb0_diff = Time.diff(time_block0.end_at, time_block0.start_at)
        tb1_diff = Time.diff(time_block1.end_at, time_block0.start_at)

        cond do
          tb0_diff > tb1_diff ->
            {time_block0.valid_from, time_block0.valid_through}
          true ->
            {time_block1.valid_from, time_block1.valid_through}
        end

      not(ts_edge_1_overlap? || ts_edge_2_overlap?) ->
        valid_from = time_blocks
          |> Enum.max_by(&to_valid_from(&1.valid_from))
          |> Map.get(:valid_from)

        valid_through = time_blocks
          |> Enum.min_by(&to_valid_through(&1.valid_through))
          |> Map.get(:valid_through)

        {valid_from, valid_through}
    end
  end


  # Split
  def split(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    valid_from = time_blocks
      |> Enum.max_by(&to_valid_from(&1.valid_from))
      |> Map.get(:valid_from)

    valid_through = time_blocks
      |> Enum.min_by(&to_valid_through(&1.valid_through))
      |> Map.get(:valid_through)

    {valid_from, valid_through}
  end
end
