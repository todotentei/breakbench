defmodule Breakbench.MMOperator.Builders.MatchMemberBuilder do
  @moduledoc false

  alias Breakbench.Accounts.{
    Match, User
  }


  def build(%Match{} = match, users) when is_list(users) do
    Enum.map(users, & build(match, &1))
  end

  def build(%Match{} = match, %User{} = user) do
    %{
      match_id: match.id,
      user_id: user.id,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
  end
end
