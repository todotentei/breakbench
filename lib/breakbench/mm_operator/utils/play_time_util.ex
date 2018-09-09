defmodule Breakbench.MMOperator.Utils.PlayTimeUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo
  alias Postgrex.{
    Interval, Range
  }

  alias Breakbench.PostgrexTypes.TsRange
  alias Breakbench.Facilities.{
    Space, GameArea
  }
  alias Breakbench.Activities.GameMode


  def next_available(%Space{} = space, %GameMode{} = game_mode,
      %Range{} = searchrange) do
    from(GameArea)
    |> join(:inner, [fld], nav in fragment("SELECT game_area_id, available FROM next_available(?,?,?)",
      ^space.id, type(^game_mode.id, :binary_id), ^searchrange), fld.id == nav.game_area_id)
    |> select([fld, nav], %{game_area: fld, available: type(nav.available, TsRange)})
    |> Repo.all
  end

  def searchrange(init, %Interval{} = duration, delay \\ %Interval{secs: 900}) do
    "SELECT searchrange FROM searchrange($1::TIMESTAMP, $2, $3)"
    |> Repo.query_one([init, duration, delay])
    |> Map.get(:searchrange)
  end
end
