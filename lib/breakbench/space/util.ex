defmodule Breakbench.SpaceUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode


  @doc """
  List of nearby opening spaces that contain searched game modes
  """
  def list(%Geo.Point{} = geom, radius, game_modes) do
    gm_ids = Enum.map(game_modes, & gm_id/1)

    from(Space)
    |> join(:inner, [spc], swi in fragment("SELECT space_id FROM space_within(?,?,?)",
      ^geom, ^radius, type(^gm_ids, {:array, :binary_id})), spc.id == swi.space_id)
    |> Repo.all
  end


  ## Private

  defp gm_id(%GameMode{id: id}), do: id
end
