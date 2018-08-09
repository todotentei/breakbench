defmodule Breakbench.StripeAPIs.Transfer do
  @moduledoc "Stripe Transfer"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  To send funds from your Stripe account to a connected account, you create a
  new transfer object. Your Stripe balance must be able to cover the transfer
  amount, or you'll receive an "Insufficient Funds" error.
  """
  def create(data) do
    request(:post, "transfers", data)
  end

  @doc """
  Retrieves the details of an existing transfer. Supply the unique transfer ID
  from either a transfer creation request or the transfer list, and Stripe will
  return the corresponding transfer information.
  """
  def retrieve(id) do
    resource = Path.join(["transfers", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified transfer by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.

  This request accepts only metadata as an argument.
  """
  def update(id, data) do
    resource = Path.join(["transfers", id])
    request(:post, resource, data)
  end

  @doc """
  Returns a list of existing transfers sent to connected accounts. The transfers
  are returned in sorted order, with the most recently created transfers appearing
  first.
  """
  def list(data \\ %{}) do
    request(:get, "transfers", data)
  end
end
