defmodule BreakbenchWeb.SessionController do
  use BreakbenchWeb, :controller

  alias Phauxth.Login
  alias Breakbench.Auth

  import Breakbench.Auth.Actions
  import Breakbench.Auth.Plugs

  plug :ensure_unauthenticated when action in [:new, :create]
  plug :ensure_ownership when action in [:delete]


  def new(conn, _params) do
    IO.inspect(conn.remote_ip)
    render(conn, "new.html")
  end

  def create(conn, %{"session" => params}) do
    case Login.verify(params) do
      {:ok, user} ->
        session_id = Login.gen_session_id("F")
        Auth.add_session(user, session_id, System.system_time(:second))

        Login.add_session(conn, session_id, user.id)
        |> add_remember_me(user.id, params)
        |> put_status(:ok)
        |> json(%{message: "Login successfully"})

      {:error, message} ->
        message = message || "Unauthorized"

        conn
        |> put_status(:unauthorized)
        |> json(%{message: message})
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    <<session_id::binary-size(17), _::binary>> = get_session(conn, :phauxth_session_id)
    Auth.delete_session(user, session_id)

    delete_session(conn, :phauxth_session_id)
    |> Phauxth.Remember.delete_rem_cookie()
    |> success("Logout successfully", page_path(conn, :index))
  end


  ## Private

  defp add_remember_me(conn, user_id, %{"remember_me" => true}) do
    cookie = Phauxth.Remember.add_rem_cookie(conn, user_id)
    IO.inspect(cookie)
    cookie
  end
  defp add_remember_me(conn, _, _), do: conn
end
