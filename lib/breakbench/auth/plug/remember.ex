defmodule Breakbench.Auth.Plug.Remember do
  @moduledoc false

  alias Breakbench.Auth
  alias Breakbench.Auth.{Config, Token}
  alias Breakbench.Accounts

  def init(opts) do
    {
      Keyword.get(opts, :max_age, Config.max_age())
    }
  end

  def call(%Plug.Conn{assigns: %{current_user: current_user}} = conn, _opts)
      when not is_nil(current_user) do
    conn
  end
  def call(%Plug.Conn{req_cookies: req_cookies} = conn, opts) do
    if token = Map.get(req_cookies, Config.remember_key()) do
      try do
        {:ok, user_id} = Token.verify(conn, token, opts)
        user = Accounts.get_user!(user_id)

        Auth.put_session(conn, user)
      rescue
        _ -> Auth.put_current_user(conn, nil)
      end
    else
      conn
    end
  end
end
