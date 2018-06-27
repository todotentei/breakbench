defmodule Breakbench.Auth do
  @moduledoc false
  alias Comeonin.Bcrypt
  alias Breakbench.Repo
  alias Breakbench.Accounts.User

  import Ecto.Query


  def authenticate_user(username_or_email, plain_text_password) do
    username_or_email
      |> query_user_by_username_or_email()
      |> Repo.one()
      |> check_password(plain_text_password)
  end


  ## Private

  # Check hash password
  defp check_password(nil, _) do
    {:error, "Incorrect username or password"}
  end

  defp check_password(%User{} = user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password_hash) do
       true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end

  # Find user by username or email
  defp query_user_by_username_or_email(username_or_email) do
      from u in User,
    where: u.username == ^username_or_email,
    where: u.email == ^username_or_email
  end
end
