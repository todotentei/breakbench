defmodule Breakbench.Auth do
  alias Comeonin.Bcrypt
  alias Breakbench.Repo
  alias Breakbench.Accounts.User

  import Ecto.Query

  def authenticate_user(username_or_email, password) do
    username_or_email
      |> query_by_username_or_email()
      |> Repo.one()
      |> check_password(password)
  end

  defp check_password(%User{} = user, password) do
    case Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end

  defp check_password(_, _) do
    {:error, "Incorrect username or password"}
  end


  ## Private

  defp query_by_username_or_email(login) do
    from user in User,
    where: user.username == ^login,
    or_where: user.email == ^login
  end
end
