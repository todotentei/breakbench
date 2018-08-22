defmodule Breakbench.MMOperator.MatchUpUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode


  def populated_spaces(%Geo.Point{} = geom, radius) do
    from(Space)
    |> join(:right, [spc], psc in fragment("SELECT space_id, game_mode_id FROM populated_spaces(?,?)",
      ^geom, ^radius), spc.id == psc.space_id)
    |> join(:left, [_, psc], gmd in GameMode, gmd.id == psc.game_mode_id)
    |> select([spc, _, gmd], %{space: spc, game_mode: gmd})
    |> Repo.all
  end
end
