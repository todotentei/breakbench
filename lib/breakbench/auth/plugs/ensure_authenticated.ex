defmodule Breakbench.Auth.Plugs.EnsureAuthenticated do
  @moduledoc false

  import Breakbench.Auth.Actions, only: [need_login: 1]


  def init(_opts), do: []

  def call(conn, opts) do
    check(conn, opts)
  end


  def check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    need_login(conn)
  end
  def check(conn, _opts) do
    conn
  end
end
