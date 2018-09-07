defmodule BreakbenchWeb.UserController do
  use BreakbenchWeb, :controller

  alias Breakbench.Accounts
  alias Breakbench.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => attrs}) do
    attrs = AtomicMap.convert(attrs, safe: false)

    case Accounts.create_user(attrs) do
      {:ok, %User{}} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Register successfully"})
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Failed to create new user"})
    end
  end
end
