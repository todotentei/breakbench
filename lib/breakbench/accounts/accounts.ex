defmodule Breakbench.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Accounts.{
    Booking,
    Match,
    MatchMember,
    UserCookie,
    User
  }

  @doc """
  Generates a changeset for the account schemas.
  """
  @spec changeset(term :: atom(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(atom, attrs \\ %{})
  def changeset(:booking, attrs) do
    Booking.changeset(%Booking{}, attrs)
  end
  def changeset(:match_member, attrs) do
    MatchMember.changeset(%MatchMember{}, attrs)
  end
  def changeset(:match, attrs) do
    Match.changeset(%Match{}, attrs)
  end
  def changeset(:user_cookie, attrs) do
    UserCookie.changeset(%UserCookie{}, attrs)
  end
  def changeset(:user, attrs) do
    User.changeset(%User{}, attrs)
  end

  @doc """
  Returns all the members of a match.
  """
  @spec list_match_members(
    term :: Match.t()
  ) :: [MatchMember.t()]
  def list_match_members(%Match{} = match) do
    match
    |> Ecto.assoc(:members)
    |> Repo.all()
  end

  @doc """
  Returns all the users.
  """
  @spec list_users() :: [User.t()]
  def list_users do
    Repo.all(User)
  end

  @doc """
  Get a booking.
  """
  @spec get_booking!(
    term :: integer() | Match.t()
  ) :: Booking.t()
  def get_booking!(%Match{} = match) do
    match
    |> Ecto.assoc(:booking)
    |> Repo.one!()
  end
  def get_booking!(id) do
    Repo.get!(Booking, id)
  end

  @doc """
  Get a match.
  """
  @spec get_match!(
    term :: binary() | Booking.t() | MatchMember.t()
  ) :: Match.t()
  def get_match!(%Booking{} = booking) do
    booking
    |> Ecto.assoc(:match)
    |> Repo.one!()
  end
  def get_match!(%MatchMember{} = member) do
    member
    |> Ecto.assoc(:match)
    |> Repo.one!()
  end
  def get_match!(id) do
    Repo.get!(Match, id)
  end

  @doc """
  Get a user cookie
  """
  @spec get_user_cookie!(
    term :: binary()
  ) :: UserCookie.t()
  def get_user_cookie!(token) do
    Repo.get!(UserCookie, token)
  end

  @doc """
  Get a user.
  """
  @spec get_user!(
    term :: integer() | MatchMember.t()
  ) :: User.t()
  def get_user!(%MatchMember{} = member) do
    member
    |> Ecto.assoc(:user)
    |> Repo.one!()
  end
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Get a user by username or email address.
  """
  @spec get_user_by_username_or_email!(
    data :: binary()
  ) :: User.t()
  def get_user_by_username_or_email!(data) do
    from(User)
    |> where(username: ^data)
    |> or_where(email: ^data)
    |> Repo.one!()
  end

  @doc """
  Checks if a user exists.
  """
  @spec has_user(attrs :: map()) :: boolean()
  def has_user(attrs) do
    Repo.has(User, attrs)
  end

  @doc """
  Inserts a booking.
  """
  @spec create_booking(
    attrs :: map()
  ) :: {:ok, Booking.t()} | {:error, Ecto.Changeset.t()}
  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts a match.
  """
  @spec create_match(
    attrs :: map()
  ) :: {:ok, Match.t()} | {:error, Ecto.Changeset.t()}
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts a user cookie.
  """
  @spec create_user_cookie(
    attrs :: map()
  ) :: {:ok, UserCookie.t()} | {:error, Ecto.Changeset.t()}
  def create_user_cookie(attrs \\ %{}) do
    %UserCookie{}
    |> UserCookie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts a user with register changeset.
  """
  @spec create_user(
    attrs :: map()
  ) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a booking.
  """
  @spec update_booking(
    booking :: Booking.t(),
    attrs :: map()
  ) :: {:ok, Booking.t()} | {:error, Ecto.Changeset.t()}
  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a match member.
  """
  @spec update_match_member(
    member :: MatchMember.t(),
    attrs :: map()
  ) :: {:ok, MatchMember.t()} | {:error, Ecto.Changeset.t()}
  def update_match_member(%MatchMember{} = member, attrs) do
    member
    |> MatchMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user.
  """
  @spec update_user(
    user :: User.t(),
    attrs :: map()
  ) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  @spec delete_user(
    user :: User.t()
  ) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
