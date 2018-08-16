defmodule Breakbench.MMOperator.PopulatedSpaceValidator do
  @moduledoc false

  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode

  def validate(attrs) do
    cond do
      !Repo.get_by(Space, id: attrs.space_id) ->
        Repo.rollback(:space_invalid)

      !Repo.get_by(GameMode, id: attrs.game_mode_id) ->
        Repo.rollback(:game_mode_invalid)

      true -> {:ok, attrs}
    end
  end
end
