defmodule Breakbench.Auth.Actions do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller
  import BreakbenchWeb.Router.Helpers

  # def login(conn, user_id) do
  #   conn
  #   |> fetch_session()
  #   |> put_session(:current_user, user_id)
  # end
  #
  # def logout(conn) do
  #   configure_session(conn, drop: true)
  # end

  def success(conn, message, path) do
    conn
    |> put_flash(:info, message)
    |> redirect(to: path)
  end

  def error(conn, message, path) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: path)
    |> halt()
  end

  def login_success(conn, path) do
    message = "Login successfully"
    path = get_session(conn, :request_path) || path

    conn
    |> delete_session(:request_path)
    |> success(message, path)
  end

  def need_login(conn) do
    message = "Login is required"
    path = session_path(conn, :new)

    conn
    |> put_session(:request_path, current_path(conn))
    |> error(message, path)
  end
end
