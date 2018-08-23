defmodule Breakbench.Balances do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Balances.OutstandingBalance


  def get_outstanding_balance!(id) do
    Repo.get! OutstandingBalance, id
  end

  def create_outstanding_balance(attrs \\ %{}) do
    %OutstandingBalance{}
    |> OutstandingBalance.changeset(attrs)
    |> Repo.insert()
  end
end
