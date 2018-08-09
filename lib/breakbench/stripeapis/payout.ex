defmodule Breakbench.StripeAPIs.Payout do
  @moduledoc "Stripe Payout"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  To send funds to your own bank account, you create a new payout object. Your
  Stripe balance must be able to cover the payout amount, or you'll receive an
  "Insufficient Funds" error.

  If you are creating a manual payout on a Stripe account that uses multiple
  payment source types, you'll need to specify he source type balance that the
  payout should draw from. The balance object details available and pending amounts
  by source type.
  """
  def create(data) do
    request(:post, "payouts", data)
  end

  @doc """
  Retrieves the details of an existing payout. Supply the unique payout ID from
  either a payout creation request or the payout list, and Stripe will return
  the corresponding payout information.
  """
  def retrieve(id) do
    resource = Path.join(["payouts", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified customer by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.
  """
  def update(id, data) do
    resource = Path.join(["payouts", id])
    request(:post, resource, data)
  end

  @doc """
  Returns a list of existing payouts sent to third-party bank accounts or that
  Stripe has sent you. The payouts are returned in sorted order, with most recently
  created payouts appearing first.
  """
  def list(data \\ %{}) do
    request(:get, "payouts", data)
  end

  @doc """
  A previously created payout can be canceled if it has not yet been paid out.
  Funds will be refunded to your available balance. You may not cancel automatic
  Stripe payouts.
  """
  def cancel(id) do
    resource = Path.join(["payouts", id, "cancel"])
    request(:post, resource, %{})
  end
end
