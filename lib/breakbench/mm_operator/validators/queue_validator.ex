defmodule Breakbench.MMOperator.QueueValidator do
  @moduledoc false

  alias Breakbench.Repo

  alias Breakbench.Accounts.User
  alias Breakbench.Activities.GameMode
  alias Breakbench.Matchmaking.MatchmakingRule, as: Rule


  def validate(attrs) do
    cond do
      !Repo.get_by(User, id: attrs.user_id) ->
        Repo.rollback(:user_invalid)

      !Repo.get_by(Rule, id: attrs.rule_id) ->
        Repo.rollback(:rule_invalid)

      length(attrs.game_modes) == 0 or
      !Enum.all?(attrs.game_modes, & Repo.get_by(GameMode, id: &1)) ->
        Repo.rollback(:game_modes_invalid)

      true -> {:ok, attrs}
    end
  end
end
