defmodule Breakbench.Exchanges do
  @moduledoc """
  The Exchanges context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Exchanges.Currency
  alias Breakbench.Accounts.Booking

  @doc """
  Generates a changeset for the exchange schemas.
  """
  @spec changeset(term :: atom()) :: Ecto.Changeset.t()
  def changeset(:currency) do
    Currency.changeset(%Currency{}, %{})
  end

  @doc """
  Get a currency.
  """
  @spec get_currency!(
    term :: binary() | Booking.t()
  ) :: Currency.t()
  def get_currency!(%Booking{} = booking) do
    booking
    |> Ecto.assoc(:currency)
    |> Repo.one!()
  end
  def get_currency!(code) do
    Repo.get!(Currency, code)
  end
end
