defmodule Breakbench.Timesheet.ValidPeriod do
  @moduledoc false


  def combine(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    ts_edge_1_overlap? = Time.compare(time_block0.start_at, time_block1.start_at) == :eq
    ts_edge_2_overlap? = Time.compare(time_block0.end_at, time_block1.end_at) == :eq

    cond do
      ts_edge_1_overlap? and ts_edge_2_overlap? ->
        valid_from = time_blocks
          |> Enum.min_by(&Map.get_lazy(&1, :valid_from, fn -> 0 end))
          |> Map.get(:valid_from)

        valid_through = time_blocks
          |> Enum.max_by(&Map.get_lazy(&1, :valid_through, fn -> :infinity end))
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
          |> Enum.max_by(&Map.get_lazy(&1, :valid_from, fn -> 0 end))
          |> Map.get(:valid_from)

        valid_through = time_blocks
          |> Enum.min_by(&Map.get_lazy(&1, :valid_through, fn -> :infinity end))
          |> Map.get(:valid_through)

        {valid_from, valid_through}
    end
  end

  def break(time_block0, time_block1) do
    time_blocks = [time_block0, time_block1]

    valid_from = time_blocks
      |> Enum.max_by(&Map.get_lazy(&1, :valid_from, fn -> 0 end))
      |> Map.get(:valid_from)

    valid_through = time_blocks
      |> Enum.min_by(&Map.get_lazy(&1, :valid_through, fn -> :infinity end))
      |> Map.get(:valid_through)

    {valid_from, valid_through}
  end

  def to_valid_from(datetime) do
    datetime || 0
  end

  def to_valid_through(datetime) do
    datetime || :infinity
  end
end
