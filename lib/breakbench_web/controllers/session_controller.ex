defmodule BreakbenchWeb.SessionController do
  use BreakbenchWeb, :controller

  alias Breakbench.Auth
  alias Breakbench.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"login" => login, "password" => pass}}) do
    case Auth.authenticate_user(login, pass) do
      {:ok, %User{id: id}} ->
        conn
          |> Auth.Actions.login(id)
          |> json(%{status: "ok", message: "Welcome back!"})
      {:error, message} ->
        json(conn, %{status: "error", message: message})
    end
  end

  def delete(conn, _params) do
    conn
      |> Auth.Actions.logout()
      |> redirect(to: page_path(conn, :index))
  end
end
