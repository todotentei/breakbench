defmodule BreakbenchWeb.UserController do
  use BreakbenchWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
