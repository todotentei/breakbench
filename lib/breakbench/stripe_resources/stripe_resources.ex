defmodule Breakbench.StripeResources do
  @moduledoc """
  The StripeResources context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.StripeResources.BalanceTransaction

  @doc """
  Returns the list of balance_transactions.

  ## Examples

      iex> list_balance_transactions()
      [%BalanceTransaction{}, ...]

  """
  def list_balance_transactions do
    Repo.all(BalanceTransaction)
  end

  @doc """
  Gets a single balance_transaction.

  Raises `Ecto.NoResultsError` if the Balance transaction does not exist.

  ## Examples

      iex> get_balance_transaction!(123)
      %BalanceTransaction{}

      iex> get_balance_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_balance_transaction!(id), do: Repo.get!(BalanceTransaction, id)

  @doc """
  Creates a balance_transaction.

  ## Examples

      iex> create_balance_transaction(%{field: value})
      {:ok, %BalanceTransaction{}}

      iex> create_balance_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_balance_transaction(attrs \\ %{}) do
    %BalanceTransaction{}
      |> BalanceTransaction.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a balance_transaction.

  ## Examples

      iex> update_balance_transaction(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_balance_transaction(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_balance_transaction(%BalanceTransaction{} = balance_transaction, attrs) do
    balance_transaction
      |> BalanceTransaction.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a BalanceTransaction.

  ## Examples

      iex> delete_balance_transaction(balance_transaction)
      {:ok, %BalanceTransaction{}}

      iex> delete_balance_transaction(balance_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_balance_transaction(%BalanceTransaction{} = balance_transaction) do
    Repo.delete(balance_transaction)
  end

  alias Breakbench.StripeResources.Customer

  @doc """
  Returns the list of customers.

  ## Examples

      iex> list_customers()
      [%Customer{}, ...]

  """
  def list_customers do
    Repo.all(Customer)
  end

  @doc """
  Gets a single customer.

  Raises `Ecto.NoResultsError` if the Customer does not exist.

  ## Examples

      iex> get_customer!(123)
      %Customer{}

      iex> get_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer!(id), do: Repo.get!(Customer, id)

  @doc """
  Creates a customer.

  ## Examples

      iex> create_customer(%{field: value})
      {:ok, %Customer{}}

      iex> create_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
      |> Customer.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a customer.

  ## Examples

      iex> update_customer(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_customer(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer(%Customer{} = customer, attrs) do
    customer
      |> Customer.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a Customer.

  ## Examples

      iex> delete_customer(customer)
      {:ok, %Customer{}}

      iex> delete_customer(customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer changes.

  ## Examples

      iex> change_customer(customer)
      %Ecto.Changeset{source: %Customer{}}

  """
  def change_customer(%Customer{} = customer) do
    Customer.changeset(customer, %{})
  end

  alias Breakbench.StripeResources.Charge

  @doc """
  Returns the list of charges.

  ## Examples

      iex> list_charges()
      [%Charge{}, ...]

  """
  def list_charges do
    Repo.all(Charge)
  end

  @doc """
  Gets a single charge.

  Raises `Ecto.NoResultsError` if the Charge does not exist.

  ## Examples

      iex> get_charge!(123)
      %Charge{}

      iex> get_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_charge!(id), do: Repo.get!(Charge, id)

  @doc """
  Creates a charge.

  ## Examples

      iex> create_charge(%{field: value})
      {:ok, %Charge{}}

      iex> create_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_charge(attrs \\ %{}) do
    %Charge{}
      |> Charge.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a charge.

  ## Examples

      iex> update_charge(charge, %{field: new_value})
      {:ok, %Charge{}}

      iex> update_charge(charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_charge(%Charge{} = charge, attrs) do
    charge
      |> Charge.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a Charge.

  ## Examples

      iex> delete_charge(charge)
      {:ok, %Charge{}}

      iex> delete_charge(charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_charge(%Charge{} = charge) do
    Repo.delete(charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking charge changes.

  ## Examples

      iex> change_charge(charge)
      %Ecto.Changeset{source: %Charge{}}

  """
  def change_charge(%Charge{} = charge) do
    Charge.changeset(charge, %{})
  end

  alias Breakbench.StripeResources.Refund

  @doc """
  Returns the list of refunds.

  ## Examples

      iex> list_refunds()
      [%Refund{}, ...]

  """
  def list_refunds do
    Repo.all(Refund)
  end

  @doc """
  Gets a single refund.

  Raises `Ecto.NoResultsError` if the Refund does not exist.

  ## Examples

      iex> get_refund!(123)
      %Refund{}

      iex> get_refund!(456)
      ** (Ecto.NoResultsError)

  """
  def get_refund!(id), do: Repo.get!(Refund, id)

  @doc """
  Creates a refund.

  ## Examples

      iex> create_refund(%{field: value})
      {:ok, %Refund{}}

      iex> create_refund(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_refund(attrs \\ %{}) do
    %Refund{}
      |> Refund.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a refund.

  ## Examples

      iex> update_refund(refund, %{field: new_value})
      {:ok, %Refund{}}

      iex> update_refund(refund, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_refund(%Refund{} = refund, attrs) do
    refund
      |> Refund.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking refund changes.

  ## Examples

      iex> change_refund(refund)
      %Ecto.Changeset{source: %Refund{}}

  """
  def change_refund(%Refund{} = refund) do
    Refund.changeset(refund, %{})
  end

  alias Breakbench.StripeResources.Payout

  @doc """
  Returns the list of payouts.

  ## Examples

      iex> list_payouts()
      [%Payout{}, ...]

  """
  def list_payouts do
    Repo.all(Payout)
  end

  @doc """
  Gets a single payout.

  Raises `Ecto.NoResultsError` if the Payout does not exist.

  ## Examples

      iex> get_payout!(123)
      %Payout{}

      iex> get_payout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payout!(id), do: Repo.get!(Payout, id)

  @doc """
  Creates a payout.

  ## Examples

      iex> create_payout(%{field: value})
      {:ok, %Payout{}}

      iex> create_payout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payout(attrs \\ %{}) do
    %Payout{}
      |> Payout.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a payout.

  ## Examples

      iex> update_payout(payout, %{field: new_value})
      {:ok, %Payout{}}

      iex> update_payout(payout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payout(%Payout{} = payout, attrs) do
    payout
    |> Payout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payout changes.

  ## Examples

      iex> change_payout(payout)
      %Ecto.Changeset{source: %Payout{}}

  """
  def change_payout(%Payout{} = payout) do
    Payout.changeset(payout, %{})
  end
end
