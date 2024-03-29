defmodule BreakbenchWeb.Auth.Plugs do
  use Plug.Builder

  plug Plug.Logger
  plug Plug.Head

  import Plug.Conn, warn: false
  import BreakbenchWeb.Auth.ErrorHandler

  alias BreakbenchWeb.Auth
  alias Breakbench.Accounts

  alias BreakbenchWeb.Auth.Config
  alias BreakbenchWeb.Auth.Token

  def load_resource(conn, _opts) do
    try do
      if user_id = get_session(conn, :user_id) do
        user = Accounts.get_user!(user_id)
        Auth.put_current_user(conn, user)
      else
        conn
      end
    rescue
      _ -> Auth.delete_session(conn)
    end
  end

  def remember_me(conn, opts) do
    token_opts = [
      max_age: Keyword.get(opts, :max_age, Config.max_age())
    ]

    cond do
      get_assign(conn, :current_user) ->
        conn

      token = get_req_cookie(conn, Config.remember_key()) ->
        try do
          user_cookie = Accounts.get_user_cookie!(token)

          with {:ok, user_id} <- Token.verify(conn, token, token_opts) do
            if user_cookie.user_id == user_id do
              user = Accounts.get_user!(user_id)
              Auth.put_session(conn, user)
            else
              raise ArgumentError, "unauthorized"
            end
          else
            {:error, message} -> raise ArgumentError, message
          end
        rescue _ ->
          conn
          |> Auth.delete_session()
          |> Auth.delete_rem_cookie()
        end

      true ->
        conn
    end
  end

  def ensure_authenticated(conn, _opts) do
    unless get_assign(conn, :current_user) do
      handle(conn, :login_required)
    else
      conn
    end
  end

  def ensure_not_authenticated(conn, _opts) do
    if get_assign(conn, :current_user) do
      handle(conn, :logout_required)
    else
      conn
    end
  end

  def ensure_ownership(conn, opts) do
    uik = Keyword.get(opts, :user_id_key, "id")

    with user_id when is_binary(user_id) <- get_param(conn, uik),
         current when not is_nil(current) <- get_assign(conn, :current_user)
    do
      unless user_id == current.id do
        handle(conn, :unauthorized)
      else
        conn
      end
    else
      _ -> handle(conn, :unauthorized)
    end
  end


  ## Private

  defp get_assign(conn, key) do
    get_in_conn(conn, :assigns, key)
  end

  defp get_param(conn, key) do
    get_in_conn(conn, :params, key)
  end

  defp get_req_cookie(conn, key) do
    get_in_conn(conn, :req_cookies, key)
  end

  defp get_in_conn(conn, key, sub_key) do
    get_in(conn, [Access.key!(key), sub_key])
  end
end
