defmodule Breakbench.PostgrexHelper do
  @moduledoc "Postgrex Helper"

  def result_to_map(%Postgrex.Result{} = result) do
    Enum.map result.rows, fn row ->
      result.columns
      |> Enum.zip(row)
      |> Map.new
      |> AtomicMap.convert(safe: false)
    end
  end

  def to_secs_interval(seconds) do
    %Postgrex.Interval{secs: seconds}
  end
end
