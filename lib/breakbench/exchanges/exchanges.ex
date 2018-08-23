defmodule Breakbench.Exchanges do
  @moduledoc """
  The Exchanges context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Exchanges.Currency
  alias Breakbench.Accounts.Booking


  def list_currencies do
    Repo.all(Currency)
  end

  def get_currency!(%Booking{} = booking) do
    booking
    |> Ecto.assoc(:currency)
    |> Repo.one!()
  end
  def get_currency!(code) do
    Repo.get!(Currency, code)
  end

  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
  end

  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  def change_currency(%Currency{} = currency) do
    Currency.changeset(currency, %{})
  end
end
