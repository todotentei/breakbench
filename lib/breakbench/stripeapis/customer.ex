defmodule Breakbench.StripeAPIs.Customer do
  @moduledoc "Stripe Customer"
  import Breakbench.StripeAPIs.Base, only: [request: 3]


  @doc """
  Creates a new customer object.
  """
  def create(data) do
    request(:post, "customers", data)
  end

  @doc """
  Retrieves the details of an existing customer. You need only supply the
  unique customer identifier that was returned upon customer creation.
  """
  def retrieve(id) do
    resource = Path.join(["customers", id])
    request(:get, resource, %{})
  end

  @doc """
  Updates the specified customer by setting the values of the parameters passed.
  Any parameters not provided will be left unchanged.
  """
  def update(id, data) do
    resource = Path.join(["customers", id])
    request(:post, resource, data)
  end

  @doc """
  Permanently deletes a customer. It cannot be undone.
  """
  def delete(id) do
    resource = Path.join(["customers", id])
    request(:delete, resource, %{})
  end

  @doc """
  Returns a list of your customers. The customers are returned sorted by
  creation date, with the most recent customers appearing first.
  """
  def list(data \\ %{}) do
    request(:get, "customers", data)
  end
end
