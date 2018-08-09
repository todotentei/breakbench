defmodule Breakbench.StripeAPIs.Charge do
  @moduledoc "Stripe Charge"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  To charge a credit card or other payment source, you create a Charge object.
  """
  def create(data) do
    request(:post, "charges", data)
  end

  @doc """
  Retrieves the details of a charge that has previously been created. Supply the
  unique charge ID that was returned from you previous request, and Stripe will
  return the corresponding charge information. The same information is returned
  when creating or refunding the charge.
  """
  def retrieve(id) do
    resource = Path.join(["charges", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified charge by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.
  """
  def update(id, data) do
    resource = Path.join(["charges", id])
    request(:post, resource, data)
  end

  @doc """
  Returns a list of charges you’ve previously created. The charges arereturned
  in sorted order, with the most recent charges appearing first.
  """
  def list(data \\ %{}) do
    request(:get, "charges", data)
  end

  @doc """
  Capture the payment of an existing, uncaptured, charge. This is the second half,
  of the two-step payment flow, where first you created a charge with the capture
  option set to false.

  Uncaptured payments expire exactly seven days after they are created. If they
  are not captured by that point in time, they will be marked as refunded and
  will no longer be captured.
  """
  def capture(id, data) do
    resource = Path.join(["charges", id, "capture"])
    request(:post, resource, data)
  end
end
