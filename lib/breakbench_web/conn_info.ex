defmodule BreakbenchWeb.ConnInfo do
  import Plug.Conn

  def remote_ip(conn) do
    case :inet_parse.ntoa(conn.remote_ip) do
      {:error, _}         -> ""
      ip when is_list(ip) -> to_string(ip)
    end
  end

  def user_agent(conn) do
    case get_req_header(conn, "user-agent") do
      [user_agent | _] -> user_agent
      _                -> ""
    end
  end
end
