defmodule Breakbench.Auth.ErrorHandler do
  use BreakbenchWeb, :controller

  def auth_error(conn, {_type, _reason}, _opts) do
    redirect(conn, to: session_path(conn, :new))
  end
end
