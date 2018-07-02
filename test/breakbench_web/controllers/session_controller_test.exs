defmodule BreakbenchWeb.SessionControllerTest do
  use BreakbenchWeb.ConnCase
  import Breakbench.Factory

  describe "login" do
    @valid_email %{login: "email@example.com", password: "Password1"}
    @valid_username %{login: "username", password: "Password1"}
    @invalid_password %{login: "username", password: "wrong_password"}
    @invalid_attrs %{login: "wrong_login", password: "wrong_password"}

    setup do
      hashpwsalt = Comeonin.Bcrypt.hashpwsalt("Password1")
      user = insert(:user, email: "email@example.com", username: "username",
        password_hash: hashpwsalt)

      {:ok, user: user}
    end

    test "returns ok when data is valid (email)", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @valid_email

      body = json_response(conn, 200)
      assert body["status"] == "ok"
    end

    test "returns ok when data is valid (username)", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @valid_username

      body = json_response(conn, 200)
      assert body["status"] == "ok"
    end

    test "returns error when password is wrong", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @invalid_password

      body = json_response(conn, 200)
      assert body["status"] == "error"
    end

    test "returns error when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @invalid_attrs

      body = json_response(conn, 200)
      assert body["status"] == "error"
    end
  end
end
