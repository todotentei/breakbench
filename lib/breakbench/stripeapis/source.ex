defmodule Breakbench.StripeAPIs.Source do
  @moduledoc "Stripe Source"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  Creates a new source object.
  """
  def create(data) do
    request(:post, "sources", data)
  end

  @doc """
  Retrieves an existing source object. Supply the unique source ID from a
  source creation request and Stripe will return the corresponding up-to-date
  source object information.
  """
  def retrieve(id) do
    resource = Path.join(["sources", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified source by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.

  This request accepts the metadata and owner as arguments. It is also possible
  to update type specific information for selected payment methods. Please
  refer to our payment method guides for more detail.
  """
  def update(id, data) do
    resource = Path.join(["sources", id])
    request(:post, resource, data)
  end

  @doc """
  Attaches a Source object to a Customer. The source must be in a chargeable
  state.
  """
  def attach(customer_id, data) do
    resource = Path.join(["customers", customer_id, "sources"])
    request(:post, resource, data)
  end

  @doc """
  Detaches a Source object from a Customer. The status of a source is changed
  to consumed when it is detached and it can no longer be used to create a
  charge.
  """
  def detach(customer_id, id) do
    resource = Path.join(["customers", customer_id, "sources", id])
    request(:delete, resource, %{})
  end
end
