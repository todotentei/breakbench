defmodule Breakbench.Auth do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Accounts
  alias Breakbench.Accounts.User

  def get(id), do: Repo.get(User, id)

  def get_by(%{"login" => username_or_email}) do
    from(User)
    |> where([u], u.username == ^username_or_email)
    |> or_where([u], u.email == ^username_or_email)
    |> Repo.one()
  end

  def list_sessions(%User{} = user) do
    user.sessions
  end

  def add_session(%User{} = user, session_id, timestamp) do
    sessions = put_in(user.sessions, [session_id], timestamp)

    Accounts.update_user(user, %{sessions: sessions})
  end

  def delete_session(%User{} = user, session_id) do
    sessions = Map.delete(user.sessions, session_id)

    Accounts.update_user(user, %{sessions: sessions})
  end
end
