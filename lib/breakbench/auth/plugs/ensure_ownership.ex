defmodule Breakbench.Auth.Plugs.EnsureOwnership do
  @moduledoc false

  import Breakbench.Auth.Actions, only: [
    error: 3,
    need_login: 1
  ]
  import BreakbenchWeb.Router.Helpers, only: [session_path: 2]


  def init(_opts), do: []

  def call(conn, opts) do
    check(conn, opts)
  end


  def check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end
  def check(
    %Plug.Conn{
      params: %{"id" => id},
      assigns: %{current_user: current_user}
    } = conn,
    _opts
  ) do
    unless id == to_string(current_user.id) do
      message = "Unauthorized"
      path = session_path(conn, :new)

      error(conn, message, path)
    else
      conn
    end
  end
end
