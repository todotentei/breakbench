defmodule Breakbench.Balances do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Balances.OutstandingBalance

  @doc """
  Generates a changeset for the balance schemas.
  """
  @spec changeset(term :: atom()) :: Ecto.Changeset.t()
  def changeset(:outstanding_balance) do
    OutstandingBalance.changeset(%OutstandingBalance{}, %{})
  end

  @doc """
  Creates an outstanding balance.
  """
  @spec create_outstanding_balance(
    attrs :: map()
  ) :: {:ok, OutstandingBalance.t()} | {:error, Ecto.Changeset.t()}
  def create_outstanding_balance(attrs \\ %{}) do
    %OutstandingBalance{}
    |> OutstandingBalance.changeset(attrs)
    |> Repo.insert()
  end
end
