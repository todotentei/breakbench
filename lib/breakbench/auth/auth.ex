defmodule Breakbench.Auth do
  @moduledoc false
  import Plug.Conn

  alias Comeonin.Bcrypt
  alias Breakbench.Accounts
  alias Breakbench.Auth.{Config, Token}

  def authenticate(username_or_email, password) do
    try do
      username_or_email
      |> Accounts.get_user_by_username_or_email!()
      |> check_password(password)
    rescue
      _ -> {:error, "Incorrest username or password"}
    end
  end

  def put_session(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def put_current_user(conn, user) do
    assign(conn, :current_user, user)
  end

  def put_rem_cookie(conn, id, max_age \\ Config.max_age()) do
    key = Config.remember_key()
    cookie = Token.sign(conn, id, [
      max_age: max_age
    ])
    opts = [
      http_only: true,
      max_age: max_age
    ]

    put_resp_cookie(conn, key, cookie, opts)
  end

  def delete_session(conn) do
    conn
    |> put_current_user(nil)
    |> delete_session(:user_id)
    |> configure_session(drop: true)
  end

  def delete_rem_cookie(conn) do
    register_before_send conn,
      fn conn ->
        key = Config.remember_key()
        delete_resp_cookie(conn, key)
      end
  end


  ## Private

  defp check_password(user, password) do
    if Bcrypt.checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Incorrest username or password"}
    end
  end
end
