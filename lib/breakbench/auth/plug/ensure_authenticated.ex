defmodule Breakbench.Auth.Plug.EnsureAuthenticated do
  @moduledoc false
  import Phoenix.Controller

  def init(_opts), do: []

  def call(%Plug.Conn{} = conn, _opts) do
    unless Map.get(conn.assigns, :current_user) do
      conn
      |> redirect(to: "/login")
      |> Plug.Conn.halt()
    else
      conn
    end
  end
  def call(conn, _opts) do
    conn
  end
end
