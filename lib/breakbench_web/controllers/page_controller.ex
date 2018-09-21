defmodule BreakbenchWeb.PageController do
  use BreakbenchWeb, :vue

  def index(conn, _params) do
    render(conn)
  end
end
