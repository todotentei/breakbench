defmodule Breakbench.SpaceUtil do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode


  @doc """
  List of nearby opening spaces that contain searched game modes
  """
  def list(%Geo.Point{} = geom, radius, game_modes) do
    gm_ids = Enum.map(game_modes, & gm_id/1)

    query = spaces_within_query(geom, radius, gm_ids)
    Repo.all(query)
  end


  ## Private

  defp gm_id(%GameMode{id: id}), do: id

  defp spaces_within_query(geom, radius, game_mode_ids) do
    from spc in Space,
      inner_join: swi in fragment("
        SELECT space_id FROM ?
      ", fn_space_within(^geom, ^radius, ^game_mode_ids))
  end
end
