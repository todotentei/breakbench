defmodule Breakbench.StripeConnectTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Repo, StripeConnect}

  describe "accounts" do
    alias Breakbench.StripeConnect.Account

    @valid_struct account_factory()

    @valid_attrs %{id: "test_account", object: "account", business_name: "Stripe.com",
      charges_enabled: false, country: "au", default_currency: "aud", details_submitted: false,
      display_name: "Stripe.com", email: "site@stripe.com", metadata: %{}, payouts_enabled: false,
      statement_descriptor: "", timezone: "US/Pacific", type: "standard"}
    @update_attrs %{default_currency: "usd"}
    @invalid_attrs %{id: nil}

    def account_fixture() do
      {:ok, account} = Repo.insert(@valid_struct)

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Enum.any?(StripeConnect.list_accounts(), &(&1.id == account.id))
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      get_account = StripeConnect.get_account!(account.id)
      assert get_account.id == account.id
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{}} = StripeConnect.create_account(@valid_attrs)
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeConnect.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      insert(:currency, code: "usd")
      account = account_fixture()
      assert {:ok, %Account{}} = StripeConnect.update_account(account, @update_attrs)
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeConnect.update_account(account, @invalid_attrs)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = StripeConnect.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> StripeConnect.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = StripeConnect.change_account(account)
    end
  end

  describe "transfers" do
    alias Breakbench.StripeConnect.Transfer

    @valid_struct transfer_factory()

    @valid_attrs %{id: "test_transfer", amount: 1100, amount_reversed: 0, balance_transaction: "test_balance_transaction",
      created: ~N[2018-05-28 16:54:17], currency: "aud", destination: "test_account",
      destination_payment: "py_Cwjc8bexq2WYfz", metadata: %{}, object: "transfer",
      reversed: false, source_type: "card", transfer_group: nil}
    @update_attrs %{metadata: %{order_id: "6735"}}
    @invalid_attrs %{id: nil}

    def transfer_fixture() do
      {:ok, transfer} = Repo.insert(@valid_struct)

      transfer
    end

    test "list_transfers/0 returns all transfers" do
      transfer = transfer_fixture()
      assert Enum.any?(StripeConnect.list_transfers(), &(&1.id == transfer.id))
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      get_transfer = StripeConnect.get_transfer!(transfer.id)
      assert get_transfer.id == transfer.id
    end

    test "create_transfer/1 with valid data creates a transfer" do
      assert {:ok, %Transfer{}} = StripeConnect.create_transfer(@valid_attrs)
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeConnect.create_transfer(@invalid_attrs)
    end

    test "update_transfer/2 with valid data updates the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = StripeConnect.update_transfer(transfer, @update_attrs)
    end

    test "update_transfer/2 with invalid data returns error changeset" do
      transfer = transfer_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeConnect.update_transfer(transfer, @invalid_attrs)
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = StripeConnect.change_transfer(transfer)
    end
  end

  describe "transfer_reversals" do
    alias Breakbench.StripeConnect.TransferReversal

    @valid_struct transfer_reversal_factory()

    @valid_attrs %{id: "test_transfer_reversal", amount: 1100, balance_transaction: "test_balance_transaction",
      created: ~N[2018-05-28 16:54:17], currency: "aud", metadata: %{}, object: "transfer_reversal",
      transfer: "test_transfer"}
    @update_attrs %{metadata: %{}}
    @invalid_attrs %{id: nil}

    def transfer_reversal_fixture() do
      {:ok, transfer_reversal} =  Repo.insert(@valid_struct)

      transfer_reversal
    end

    test "list_transfer_reversals/0 returns all transfer_reversals" do
      transfer_reversal = transfer_reversal_fixture()
      assert Enum.any?(StripeConnect.list_transfer_reversals(), &(&1.id == transfer_reversal.id))
    end

    test "get_transfer_reversal!/1 returns the transfer_reversal with given id" do
      transfer_reversal = transfer_reversal_fixture()
      get_transfer_reversal = StripeConnect.get_transfer_reversal!(transfer_reversal.id)
      assert get_transfer_reversal.id == transfer_reversal.id
    end

    test "create_transfer_reversal/1 with valid data creates a transfer_reversal" do
      assert {:ok, %TransferReversal{}} = StripeConnect.create_transfer_reversal(@valid_attrs)
    end

    test "create_transfer_reversal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeConnect.create_transfer_reversal(@invalid_attrs)
    end

    test "update_transfer_reversal/2 with valid data updates the transfer_reversal" do
      transfer_reversal = transfer_reversal_fixture()
      assert {:ok, %TransferReversal{}} = StripeConnect.update_transfer_reversal(transfer_reversal, @update_attrs)
    end

    test "update_transfer_reversal/2 with invalid data returns error changeset" do
      transfer_reversal = transfer_reversal_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeConnect.update_transfer_reversal(transfer_reversal, @invalid_attrs)
    end

    test "change_transfer_reversal/1 returns a transfer_reversal changeset" do
      transfer_reversal = transfer_reversal_fixture()
      assert %Ecto.Changeset{} = StripeConnect.change_transfer_reversal(transfer_reversal)
    end
  end
end
