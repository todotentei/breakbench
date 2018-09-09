defmodule Breakbench.Auth.Plug.EnsureOwnership do
  @moduledoc false
  import Phoenix.Controller

  def init(_opts), do: []

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    redirect(conn, to: "/login")
  end
  def call(
    %Plug.Conn{
      params: %{"id" => id},
      assigns: %{current_user: current_user}
    } = conn,
    _opts
  ) do
    unless id == to_string(current_user.id) do
      conn
      |> redirect(to: "/")
      |> Plug.Conn.halt()
    else
      conn
    end
  end
end
