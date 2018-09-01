defmodule BreakbenchWeb.UserController do
  use BreakbenchWeb, :controller

  alias Breakbench.Accounts
  alias Breakbench.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "email" => email,
      "password" => password}}) do
    attrs = %{username: username, email: email, password: password}
    case Accounts.create_user(attrs) do
      {:ok, %User{}} ->
        conn
        # conn
        #   |> Auth.Actions.login(id)
        #   |> json(%{status: "ok", message: "You have been successfully registered and logged in"})
      {:error, _} ->
        json(conn, %{status: "error", message: "Failed to create new user"})
    end
  end
end
