defmodule Breakbench.RegisterTest do
  use BreakbenchWeb.IntegrationCase, async: true

  import Wallaby.Query
  import Breakbench.Factory

  describe "register form validation" do
    setup do
      hashpwsalt = Comeonin.Bcrypt.hashpwsalt("Password1")
      user = insert(:user, email: "exist.email@example.com", username: "exist_username",
        password_hash: hashpwsalt)

      {:ok, user: user}
    end

    test "required validation", context do
      context.session
      |> visit("/register")
      |> click(button("Create new account"))
      |> assert_has(css(".av-submitted.av-invalid"))
      |> assert_has(css(".invalid-feedback", count: 3))
    end

    test "validate username valid characters", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("username"), with: "correct_username")
      |> refute_has(css(".invalid-feedback"))
      |> fill_in(text_field("username"), with: "!wrøng-username")
      |> assert_has(css(".invalid-feedback", text: "Your username must be composed only with letter, numbers, and underscore"))
    end

    test "validate username length", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("username"), with: "valid_username")
      |> refute_has(css(".invalid-feedback"))
      |> clear(text_field("username"))
      |> fill_in(text_field("username"), with: "abc")
      |> assert_has(css(".invalid-feedback", text: "Must be 5 characters or more"))
    end

    test "validate unique username", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("username"), with: "new_username")
      |> refute_has(css(".invalid-feedback"))
      |> fill_in(text_field("username"), with: "exist_username")
      |> assert_has(css(".invalid-feedback", text: "Username is already taken"))
    end

    test "validate email format", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("email"), with: "email@example.com")
      |> refute_has(css(".invalid-feedback"))
      |> fill_in(text_field("email"), with: "plain-text")
      |> assert_has(css(".invalid-feedback", text: "Your email address is invalid"))
    end

    test "validate unique email", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("email"), with: "new.email@example.com")
      |> refute_has(css(".invalid-feedback"))
      |> fill_in(text_field("email"), with: "exist.email@example.com")
      |> assert_has(css(".invalid-feedback", text: "Email address is already taken"))
    end

    test "validate password length", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("password"), with: "Password1")
      |> refute_has(css(".invalid-feedback"))
      |> fill_in(text_field("password"), with: "short")
      |> assert_has(css(".invalid-feedback", text: "Must be 8 characters or more"))
    end
  end

  describe "registration" do
    test "valid register", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("username"), with: "username")
      |> fill_in(text_field("email"), with: "email@example.com")
      |> fill_in(text_field("password"), with: "Password1")
      |> click(button("Create new account"))
    end

    test "invalid register", context do
      context.session
      |> visit("/register")
      |> fill_in(text_field("username"), with: "exist_username")
      |> fill_in(text_field("email"), with: "exist.email@example.com")
      |> fill_in(text_field("password"), with: "Password1")
      |> click(button("Create new account"))
    end
  end
end
