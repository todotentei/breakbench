defmodule Breakbench.StripeAPIs.Account do
  @moduledoc "Stripe Account"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  With Connect, you can create Stripe accounts for your users.
  """
  def create(data) do
    request(:post, "accounts", data)
  end

  @doc """
  Retrieves the details of the account.
  """
  def retrieve(id) do
    resource = Path.join(["accounts", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates a connect account by setting the values of the parameters passed.
  Any parameters not provided are left unchanged.
  """
  def update(id, data) do
    resource = Path.join(["accounts", id])
    request(:post, resource, data)
  end

  @doc """
  Custom accounts created using live-mode keys may only be deleted once all
  balances are zero.
  """
  def delete(id) do
    resource = Path.join(["accounts", id])
    request(:delete, resource, %{})
  end

  @doc """
  Custom accounts created using live-mode keys may only be deleted once all
  balances are zero.
  """
  def list(data \\ %{}) do
    request(:get, "accounts", data)
  end

  @doc """
  Accounts created using live-mode keys may only be rejected once all balances
  are zero.
  """
  def reject(id, data) do
    resource = Path.join(["accounts", id, "reject"])
    request(:post, resource, data)
  end
end
