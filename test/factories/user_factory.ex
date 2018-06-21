defmodule Breakbench.UserFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Accounts.User

      def user_factory do
        %User{
          first_name: "first_name",
          middle_name: "middle_name",
          last_name: "last_name",
          given_name: "given_name",
          email: sequence(:email, &"email-#{&1}@example.com"),
          date_of_birth: ~D[1995-01-01],
          gender: "male",
          username: sequence(:username, &"username_#{&1}"),
          password_hash: "password_hash"
        }
      end
    end
  end
end
