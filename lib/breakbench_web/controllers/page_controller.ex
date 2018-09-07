defmodule BreakbenchWeb.PageController do
  use BreakbenchWeb, :controller

  import Breakbench.Auth.Plugs

  plug :ensure_authenticated when action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
