defmodule Breakbench.MMOperator.QueueBuilder do
  @moduledoc false

  alias Breakbench.Accounts.User
  alias Breakbench.Matchmaking.MatchmakingRule, as: Rule


  def build(%User{} = user, %Rule{} = rule, %Geo.Point{} = geom) do
    %{
      user_id: user.id,
      rule_id: rule.id,
      geom: geom
    }
  end
end
