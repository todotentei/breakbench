defmodule BreakbenchWeb.AccountResolver do
  @moduledoc false
  alias Breakbench.Repo
  alias Breakbench.Accounts

  def list_users(_, _, _) do
    users = Accounts.list_users()

    {:ok, users}
  end

  def has_user(_, attrs, _) do
    boolean = Accounts.has_user(attrs)

    {:ok, boolean}
  end
end
