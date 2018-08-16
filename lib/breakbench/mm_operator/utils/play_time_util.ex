defmodule Breakbench.MMOperator.PlayTimeUtil do
  @moduledoc false

  import Ecto.Query
  alias Postgrex.Range
  alias Breakbench.Repo

  alias Breakbench.PostgrexTypes.TsRange
  alias Breakbench.Facilities.{
    Space, Field
  }
  alias Breakbench.Activities.GameMode


  def next_available(%Space{} = space, %GameMode{} = game_mode,
      %Range{} = searchrange) do
    from(Field)
    |> join(:inner, [fld], nav in fragment("SELECT field_id, available FROM next_available(?,?,?)",
        ^space.id, type(^game_mode.id, :binary_id), ^searchrange), fld.id == nav.field_id)
    |> select([fld, nav], %{field: fld, available: type(nav.available, TsRange)})
    |> Repo.all
  end
end
