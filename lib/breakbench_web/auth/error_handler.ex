defmodule BreakbenchWeb.Auth.ErrorHandler do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller

  @spec handle(
    conn   :: Plug.Conn.t,
    type   :: atom,
    reason :: binary
  ) :: Plug.Conn.t
  def handle(conn, type, reason \\ "")

  def handle(conn, :unauthorized, _) do
    conn
    |> redirect(to: "/")
    |> halt()
  end

  def handle(conn, :logout_required, _) do
    conn
    |> redirect(to: "/")
    |> halt()
  end

  def handle(conn, :login_required, _) do
    conn
    |> redirect(to: "/login")
    |> halt()
  end

  def handle(conn, _, _), do: halt(conn)
end
