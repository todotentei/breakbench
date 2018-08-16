defmodule Breakbench.PostgrexHelper do
  @moduledoc "Postgrex Helper"


  def result_to_map(%Postgrex.Result{columns: columns, rows: rows, num_rows: num_rows}) do
    Enum.map rows, fn row ->
      columns
      |> Enum.zip(row)
      |> Map.new
      |> AtomicMap.convert(safe: false)
    end
  end

  def to_secs_interval(seconds) do
    %Postgrex.Interval{secs: seconds}
  end
end
