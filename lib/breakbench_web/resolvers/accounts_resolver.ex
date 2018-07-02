defmodule BreakbenchWeb.AccountsResolver do
  alias Breakbench.Accounts
  alias Breakbench.Repo

  def all_users(_root, _args, _info) do
    users = Accounts.list_users()
    {:ok, users}
  end

  def get_user(_root, %{id: id}, _info) do
    try do
      user = Accounts.get_user!(id)
      {:ok, user}
    rescue e in Ecto.NoResultsError ->
      {:error, e.message}
    end
  end

  def has_user(_root, clauses, _info) do
    exist? = Repo.has?(Accounts.User, clauses)
    {:ok, exist?}
  end
end
