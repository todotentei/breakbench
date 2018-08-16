defmodule Breakbench.MMOperator.SearchRangeBuilder do
  @moduledoc false

  alias Breakbench.Repo
  alias Postgrex.Interval

  import Breakbench.PostgrexHelper, only: [result_to_map: 1]


  def build(init, %Interval{} = duration, delay \\ %Interval{secs: 900}) do
    "
      SELECT searchrange
      FROM searchrange($1::TIMESTAMP, $2, $3)
    "
    |> Repo.query!([init, duration, delay])
    |> result_to_map()
    |> hd()
    |> Map.get(:searchrange)
  end
end
