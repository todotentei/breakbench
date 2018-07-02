defmodule Breakbench.EnsureAuthenticated do
  import Plug.Conn
  alias BreakbenchWeb.Router.Helpers, as: Router

  def init(opts) do
    opts
  end

  def call(conn, _) do
    conn = fetch_session(conn)

    current_user = get_session(conn, :current_user)
    case current_user do
      nil ->
        login_path = Router.session_path(conn, :new)
        conn
          |> Phoenix.Controller.redirect(to: login_path)
          |> halt()
      _ ->
        assign(conn, :current_user, current_user)
    end
  end
end
