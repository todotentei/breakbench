defmodule Breakbench.MMOperator.Utils.PlayTimeUtil do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

  alias Breakbench.Repo
  alias Postgrex.Interval
  alias Postgrex.Range

  alias Breakbench.PostgrexTypes.TsRange
  alias Breakbench.Facilities.Space
  alias Breakbench.Facilities.GameArea
  alias Breakbench.Activities.GameMode


  def next_available(%Space{} = space, %GameMode{} = game_mode, %Range{} = searchrange) do
    query = na_query(space.id, game_mode.id, searchrange)
    Repo.all(query)
  end

  def searchrange(init, %Interval{} = duration, delay \\ %Interval{secs: 900}) do
    "SELECT searchrange FROM searchrange($1::TIMESTAMP, $2, $3)"
    |> Repo.query_one([init, duration, delay])
    |> Map.get(:searchrange)
  end


  ## Private

  defp na_query(space_id, game_mode_id, searchrange) do
    from gaa in GameArea,
      inner_join: nav in fragment("
        SELECT game_area_id, available FROM ?
      ", fn_next_available(^space_id, ^game_mode_id, ^searchrange)),
        on: gaa.id == nav.game_area_id,
      select: %{
        game_area: gaa,
        available: type(nav.available, TsRange)
      }
  end
end
