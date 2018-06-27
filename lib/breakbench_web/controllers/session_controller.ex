defmodule BreakbenchWeb.SessionController do
  use BreakbenchWeb, :controller

  alias Breakbench.Auth
  alias Breakbench.Auth.Guardian


  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"login" => login, "password" => pass}}) do
    case Auth.authenticate_user(login, pass) do
      {:ok, user} ->
        conn
          |> Guardian.Plug.sign_in(user)
          |> redirect(to: "/")
      {:error, _} ->
        json conn, %{type: "error", message: "Incorrect username or password."}
    end
  end

  def delete(conn, _params) do
    conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: page_path(conn, :new))
  end
end
