defmodule BreakbenchWeb.SessionController do
  use BreakbenchWeb, :controller

  alias Breakbench.Auth
  alias Breakbench.Auth.Plug

  plug Plug.EnsureNotAuthenticated when action in [:new, :create]
  plug Plug.EnsureOwnership when action in [:delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{
    "username_or_email" => username_or_email,
    "password" => password
  }}) do
    case Auth.authenticate(username_or_email, password) do
      {:ok, user} ->
        conn
        |> Auth.put_session(user)
        |> Auth.put_rem_cookie(user.id)
        |> put_status(:ok)
        |> json(%{message: "Login successfully"})

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{message: message})
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.delete_session()
    |> Auth.delete_rem_cookie()
    |> redirect(to: page_path(conn, :index))
  end
end
