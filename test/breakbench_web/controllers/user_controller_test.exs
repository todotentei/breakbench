defmodule BreakbenchWeb.UserControllerTest do
  use BreakbenchWeb.ConnCase
  import Breakbench.Factory

  describe "register" do
    @valid_attrs %{username: "username", email: "email@example.com",
      password: "Password1"}

    setup do
      hashpwsalt = Comeonin.Bcrypt.hashpwsalt("Password1")
      user = insert(:user, email: "exist.email@example.com",
        username: "exist_username", password_hash: hashpwsalt)

      {:ok, user: user}
    end

    test "returns ok when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @valid_attrs

      body = json_response(conn, 200)
      assert body["status"] == "ok"
    end

    test "returns error when username is not unique", %{conn: conn} do
      invalid_username = %{@valid_attrs | username: "exist_username"}
      conn = post conn, user_path(conn, :create), user: invalid_username
      
      body = json_response(conn, 200)
      assert body["status"] == "error"
    end

    test "return error when email is not unique", %{conn: conn} do
      invalid_email = %{@valid_attrs | email: "exist.email@example.com"}
      conn = post conn, user_path(conn, :create), user: invalid_email

      body = json_response(conn, 200)
      assert body["status"] == "error"
    end
  end
end
