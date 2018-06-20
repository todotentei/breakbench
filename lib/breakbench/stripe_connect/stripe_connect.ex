defmodule Breakbench.StripeConnect do
  @moduledoc """
  The StripeConnect context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.StripeConnect.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
      |> Account.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
      |> Account.changeset(attrs)
      |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  alias Breakbench.StripeConnect.Transfer

  @doc """
  Returns the list of transfers.

  ## Examples

      iex> list_transfers()
      [%Transfer{}, ...]

  """
  def list_transfers do
    Repo.all(Transfer)
  end

  @doc """
  Gets a single transfer.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer!(123)
      %Transfer{}

      iex> get_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer!(id), do: Repo.get!(Transfer, id)

  @doc """
  Creates a transfer.

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(attrs \\ %{}) do
    %Transfer{}
    |> Transfer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> update_transfer(transfer, %{field: new_value})
      {:ok, %Transfer{}}

      iex> update_transfer(transfer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer(%Transfer{} = transfer, attrs) do
    transfer
    |> Transfer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer changes.

  ## Examples

      iex> change_transfer(transfer)
      %Ecto.Changeset{source: %Transfer{}}

  """
  def change_transfer(%Transfer{} = transfer) do
    Transfer.changeset(transfer, %{})
  end

  alias Breakbench.StripeConnect.TransferReversal

  @doc """
  Returns the list of transfer_reversals.

  ## Examples

      iex> list_transfer_reversals()
      [%TransferReversal{}, ...]

  """
  def list_transfer_reversals do
    Repo.all(TransferReversal)
  end

  @doc """
  Gets a single transfer_reversal.

  Raises `Ecto.NoResultsError` if the Transfer reversal does not exist.

  ## Examples

      iex> get_transfer_reversal!(123)
      %TransferReversal{}

      iex> get_transfer_reversal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer_reversal!(id), do: Repo.get!(TransferReversal, id)

  @doc """
  Creates a transfer_reversal.

  ## Examples

      iex> create_transfer_reversal(%{field: value})
      {:ok, %TransferReversal{}}

      iex> create_transfer_reversal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer_reversal(attrs \\ %{}) do
    %TransferReversal{}
      |> TransferReversal.changeset(attrs)
      |> Repo.insert()
  end

  @doc """
  Updates a transfer_reversal.

  ## Examples

      iex> update_transfer_reversal(transfer_reversal, %{field: new_value})
      {:ok, %TransferReversal{}}

      iex> update_transfer_reversal(transfer_reversal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer_reversal(%TransferReversal{} = transfer_reversal, attrs) do
    transfer_reversal
    |> TransferReversal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer_reversal changes.

  ## Examples

      iex> change_transfer_reversal(transfer_reversal)
      %Ecto.Changeset{source: %TransferReversal{}}

  """
  def change_transfer_reversal(%TransferReversal{} = transfer_reversal) do
    TransferReversal.changeset(transfer_reversal, %{})
  end
end
