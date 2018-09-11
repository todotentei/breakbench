defmodule Breakbench.MMOperator.Utils.MatchUpUtil do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode


  def populated_spaces(%Geo.Point{} = geom, radius) do
    query = ps_query(geom, radius)
    Repo.all(query)
  end


  ## Private

  defp ps_query(geom, radius) do
    from spc in Space,
      right_join: psc in fragment("
        SELECT space_id, game_mode_id FROM ?
      ", fn_populated_spaces(^geom, ^radius)),
        on: spc.id == psc.space_id,
      left_join: gmd in GameMode,
        on: gmd.id == psc.game_mode_id,
      select: %{
        space: spc,
        game_mode: gmd
      }
  end
end
