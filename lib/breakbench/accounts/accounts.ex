defmodule Breakbench.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo


  # Booking

  alias Breakbench.Accounts.Booking

  def list_bookings do
    Repo.all(Booking)
  end

  def get_booking!(id), do: Repo.get!(Booking, id)

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


  # User

  alias Breakbench.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

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
