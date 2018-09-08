defmodule Breakbench.Auth.Plug.EnsureNotAuthenticated do
  @moduledoc false
  import Phoenix.Controller

  def init(_opts), do: []

  def call(%Plug.Conn{} = conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      redirect(conn, to: "/")
    else
      conn
    end
  end
end
