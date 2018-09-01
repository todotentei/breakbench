defmodule Breakbench.Auth.Plugs.EnsureUnauthenticated do
  @moduledoc false

  import Breakbench.Auth.Actions, only: [error: 3]
  import BreakbenchWeb.Router.Helpers, only: [page_path: 2]


  def init(_opts), do: []

  def call(conn, opts) do
    check(conn, opts)
  end


  def check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
  end
  def check(%Plug.Conn{assigns: %{current_user: _}} = conn, _opts) do
    message = "Logout is required"
    path = page_path(conn, :index)

    error(conn, message, path)
  end
end
