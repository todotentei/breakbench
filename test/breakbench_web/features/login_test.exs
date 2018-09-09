defmodule Breakbench.LoginTest do
  use BreakbenchWeb.IntegrationCase, async: true

  import Wallaby.Query
  import Breakbench.Factory

  describe "login authentication" do
    test "valid login", context do
      hashpwsalt = Comeonin.Bcrypt.hashpwsalt("Password1")
      insert(:user, email: "email@example.com", username: "username",
        password_hash: hashpwsalt)

      context.session
      |> visit("/login")
      |> fill_in(text_field("login"), with: "username")
      |> fill_in(text_field("password"), with: "Password1")
      |> click(button("Sign in to your account"))
      |> refute_has(css(".flash.flash-danger"))
    end

    test "invalid login", context do
      context.session
      |> visit("/login")
      |> fill_in(text_field("login"), with: "wrong_username")
      |> fill_in(text_field("password"), with: "wrong_password")
      |> click(button("Sign in to your account"))
      |> assert_has(css(".flash.flash-danger > .flash-body",
        text: "Incorrect username or password"))
    end
  end
end
