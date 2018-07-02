defmodule Breakbench.Auth.Actions do
  import Plug.Conn

  def login(conn, user_id) do
    conn
      |> fetch_session()
      |> put_session(:current_user, user_id)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
