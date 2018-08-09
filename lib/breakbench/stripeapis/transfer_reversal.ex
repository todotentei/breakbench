defmodule Breakbench.StripeAPIs.TransferReversal do
  @moduledoc "Stripe TransferReversal"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  When you create a new reversal, you must specify a transfer to create it on.

  When reversing transfers, you can optionally reverse part of the transfer.
  You can do so as many times as you wish until the entire transfer has been
  reversed.

  Once entirely reversed, a transfer can't be reversed again. This method will
  return an error when called on an already-reversed transfer, or when trying
  to reverse more money than is left on a transfer/
  """
  def create(id, data) do
    resource = Path.join(["transfers", id, "reversals"])
    request(:post, resource, data)
  end

  @doc """
  Retrieves details about a specific reversal stored on the transfer.
  """
  def retrieve(id, reversal_id) do
    resource = Path.join(["transfers", id, "reversals", reversal_id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified reversal by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.

  This request only accepts metadata and description as arguments.
  """
  def update(id, reversal_id, data) do
    resource = Path.join(["transfers", id, "reversals", reversal_id])
    request(:post, resource, data)
  end

  @doc """
  You can see a list of the reversals belonging to a specific transfer. Note that
  the 10 most recent reversals are always available by default on the transfer
  object. If you need more than those 10, you can use this API method and the
  limit and starting_after parameters to page through additional reversals.
  """
  def list(id, data \\ %{}) do
    resource = Path.join(["transfers", id, "reversals"])
    request(:get, resource, data)
  end
end
