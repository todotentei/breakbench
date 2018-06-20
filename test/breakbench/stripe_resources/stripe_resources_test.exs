defmodule Breakbench.StripeResourcesTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.{Repo, StripeResources}

  describe "balance_transactions" do
    alias Breakbench.StripeResources.BalanceTransaction

    @valid_struct balance_transaction_factory()

    @valid_attrs %{id: "test_balance_transaction", object: "balance_transaction",
      amount: 100, available_on: ~N[2018-05-28 16:54:17], created: ~N[2018-05-28 16:54:17],
      currency: "aud", fee: 0, fee_details: [], net: 100, status: "pending", type: "charge"}
    @update_attrs %{}
    @invalid_attrs %{id: nil}

    def balance_transaction_fixture() do
      {:ok, balance_transaction} = Repo.insert(@valid_struct)

      balance_transaction
    end

    test "list_balance_transactions/0 returns all balance_transactions" do
      balance_transaction = balance_transaction_fixture()
      assert Enum.any?(StripeResources.list_balance_transactions(), &(&1.id == balance_transaction.id))
    end

    test "get_balance_transaction!/1 returns the balance_transaction with given id" do
      balance_transaction = balance_transaction_fixture()
      get_balance_transaction = StripeResources.get_balance_transaction!(balance_transaction.id)
      assert get_balance_transaction.id == balance_transaction.id
    end

    test "create_balance_transaction/1 with valid data creates a balance_transaction" do
      assert {:ok, %BalanceTransaction{}} = StripeResources.create_balance_transaction(@valid_attrs)
    end

    test "create_balance_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeResources.create_balance_transaction(@invalid_attrs)
    end

    test "update_balance_transaction/2 with valid data updates the balance_transaction" do
      balance_transaction = balance_transaction_fixture()
      assert {:ok, %BalanceTransaction{}} = StripeResources.update_balance_transaction(balance_transaction, @update_attrs)
    end

    test "update_balance_transaction/2 with invalid data returns error changeset" do
      balance_transaction = balance_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeResources.update_balance_transaction(balance_transaction, @invalid_attrs)
    end

    test "delete_balance_transaction/1 deletes the balance_transaction" do
      balance_transaction = balance_transaction_fixture()
      assert {:ok, %BalanceTransaction{}} = StripeResources.delete_balance_transaction(balance_transaction)
      assert_raise Ecto.NoResultsError, fn -> StripeResources.get_balance_transaction!(balance_transaction.id) end
    end
  end

  describe "customers" do
    alias Breakbench.StripeResources.Customer

    @valid_struct customer_factory()

    @valid_attrs %{id: "test_customer", object: "customer", account_balance: 0,
      created: ~N[2018-05-28 16:54:17], currency: "aud", delinquent: false,
      invoice_prefix: "51B0154", metadata: %{}}
    @update_attrs %{account_balance: 10, description: "updated", email: "updated@example.com",
      invoice_prefix: "updated", metadata: %{updated: true}}
    @invalid_attrs %{id: nil}

    def customer_fixture() do
      {:ok, customer} = Repo.insert(@valid_struct)

      customer
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Enum.all?(StripeResources.list_customers(), &(&1.id == customer.id))
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      get_customer = StripeResources.get_customer!(customer.id)
      assert get_customer.id == customer.id
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{}} = StripeResources.create_customer(@valid_attrs)
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeResources.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = StripeResources.update_customer(customer, @update_attrs)
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeResources.update_customer(customer, @invalid_attrs)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = StripeResources.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> StripeResources.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = StripeResources.change_customer(customer)
    end
  end

  describe "charges" do
    alias Breakbench.StripeResources.Charge

    @valid_struct charge_factory()

    @valid_attrs %{id: "test_charge", metadata: %{}, currency: "aud", balance_transaction: "test_balance_transaction",
      customer: "test_customer", destination: "test_account", description: "My First Test Charge (created for API docs)",
      refunded: false, fraud_details: %{}, on_behalf_of: "test_account", paid: true,
      created: ~N[2018-05-28 16:54:17], amount_refunded: 0, captured: false, source_transfer: "test_transfer",
      transfer: "test_transfer", amount: 100, object: "charge", status: "succeeded"}
    @update_attrs %{customer: "new_customer", description: "Charge for liam.harris@example.com",
      fraud_details: %{user_report: "safe"}, metadata: %{updated: true}, receipt_email: nil,
      shipping: nil}
    @invalid_attrs %{id: nil}

    def charge_fixture() do
      {:ok, charge} = Repo.insert(@valid_struct)

      charge
    end

    test "list_charges/0 returns all charges" do
      charge = charge_fixture()
      assert Enum.all?(StripeResources.list_charges(), &(&1.id == charge.id))
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      get_charge = StripeResources.get_charge!(charge.id)
      assert get_charge.id == charge.id
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{}} = StripeResources.create_charge(@valid_attrs)
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeResources.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      insert(:customer, id: "new_customer")
      charge = charge_fixture()
      assert {:ok, %Charge{}} = StripeResources.update_charge(charge, @update_attrs)
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeResources.update_charge(charge, @invalid_attrs)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = StripeResources.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> StripeResources.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = StripeResources.change_charge(charge)
    end
  end

  describe "refunds" do
    alias Breakbench.StripeResources.Refund

    @valid_struct refund_factory()

    @valid_attrs %{id: "test_refund", balance_transaction: "test_balance_transaction",
      charge: "test_charge", currency: "aud", amount: 100, created: ~N[2018-05-28 16:54:17],
      metadata: %{}, object: "refund", status: "succeeded"}
    @update_attrs %{metadata: %{account_id: "test-account", instrument_id: "2a9c8101-1907-40aa-bda0-d46b82676c51"}}
    @invalid_attrs %{id: nil}

    def refund_fixture() do
      {:ok, refund} = Repo.insert(@valid_struct)

      refund
    end

    test "list_refunds/0 returns all refunds" do
      refund = refund_fixture()
      assert Enum.all?(StripeResources.list_refunds(), &(&1.id == refund.id))
    end

    test "get_refund!/1 returns the refund with given id" do
      refund = refund_fixture()
      get_refund = StripeResources.get_refund!(refund.id)
      assert get_refund.id == refund.id
    end

    test "test_refund/1 with valid data creates a refund" do
      assert {:ok, %Refund{}} = StripeResources.create_refund(@valid_attrs)
    end

    test "create_refund/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeResources.create_refund(@invalid_attrs)
    end

    test "update_refund/2 with valid data updates the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{}} = StripeResources.update_refund(refund, @update_attrs)
    end

    test "update_refund/2 with invalid data returns error changeset" do
      refund = refund_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeResources.update_refund(refund, @invalid_attrs)
    end

    test "change_refund/1 returns a refund changeset" do
      refund = refund_fixture()
      assert %Ecto.Changeset{} = StripeResources.change_refund(refund)
    end
  end

  describe "payouts" do
    alias Breakbench.StripeResources.Payout

    @valid_struct payout_factory()

    @valid_attrs %{id: "test_payout", amount: 1100, arrival_date: ~N[2018-05-28 16:54:17], automatic: true,
      balance_transaction: "test_balance_transaction", created: ~N[2018-05-28 16:54:17], currency: "aud",
      description: "STRIPE TRANSFER", metadata: %{}, method: "standard", object: "payout",
      source_type: "card", status: "in_transit", type: "bank_account"}
    @update_attrs %{metadata: %{}}
    @invalid_attrs %{id: nil}

    def payout_fixture() do
      {:ok, payout} = Repo.insert(@valid_struct)

      payout
    end

    test "list_payouts/0 returns all payouts" do
      payout = payout_fixture()
      assert Enum.all?(StripeResources.list_payouts(), &(&1.id == payout.id))
    end

    test "get_payout!/1 returns the payout with given id" do
      payout = payout_fixture()
      get_payout = StripeResources.get_payout!(payout.id)
      assert get_payout.id == payout.id
    end

    test "create_payout/1 with valid data creates a payout" do
      assert {:ok, %Payout{}} = StripeResources.create_payout(@valid_attrs)
    end

    test "create_payout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripeResources.create_payout(@invalid_attrs)
    end

    test "update_payout/2 with valid data updates the payout" do
      payout = payout_fixture()
      assert {:ok, %Payout{}} = StripeResources.update_payout(payout, @update_attrs)
    end

    test "update_payout/2 with invalid data returns error changeset" do
      payout = payout_fixture()
      assert {:error, %Ecto.Changeset{}} = StripeResources.update_payout(payout, @invalid_attrs)
    end

    test "change_payout/1 returns a payout changeset" do
      payout = payout_fixture()
      assert %Ecto.Changeset{} = StripeResources.change_payout(payout)
    end
  end
end
