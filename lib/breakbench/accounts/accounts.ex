defmodule Breakbench.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Accounts.{
    Booking, Match, MatchMember, User
  }


  # Booking

  def list_bookings do
    Repo.all(Booking)
  end

  def get_booking!(%Match{} = match) do
    match
    |> Ecto.assoc(:booking)
    |> Repo.one!()
  end
  def get_booking!(id) do
    Repo.get!(Booking, id)
  end

  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  def change_booking(%Booking{} = booking) do
    Booking.changeset(booking, %{})
  end


  # Match

  def list_matches do
    Repo.all Match
  end

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
    Repo.get! Match, id
  end

  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def delete_match(%Match{} = match) do
    Repo.delete match
  end


  # Match Member

  def list_match_members do
    Repo.all MatchMember
  end
  def list_match_members(%Match{} = match) do
    match
    |> Ecto.assoc(:members)
    |> Repo.all()
  end

  def get_match_member!(id) do
    Repo.get! MatchMember, id
  end

  def create_match_member(attrs \\ %{}) do
    %MatchMember{}
    |> MatchMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_match_member(%MatchMember{} = member, attrs) do
    member
    |> MatchMember.changeset(attrs)
    |> Repo.update()
  end

  def delete_match_member(%MatchMember{} = match_member) do
    Repo.delete match_member
  end


  # User

  def list_users do
    Repo.all(User)
  end

  def get_user!(%MatchMember{} = member) do
    member
    |> Ecto.assoc(:user)
    |> Repo.one!()
  end
  def get_user!(id), do: Repo.get!(User, id)

  def has_user(attrs) do
    Repo.has(User, attrs)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
