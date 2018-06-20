defmodule Breakbench.StripePaymentMethodsTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.StripePaymentMethods

  describe "bank_accounts" do
    alias Breakbench.StripePaymentMethods.BankAccount

    @valid_struct bank_account_factory()

    @valid_attrs %{id: "test_bank_account", account: "test_account", account_holder_name: "Jane Austen",
      account_holder_type: "individual", bank_name: "STRIPE TEST BANK", country: "au",
      currency: "aud", customer: "test_customer", default_for_currency: false,
      fingerprint: "vZDTTGwnLhYpF78J", last4: "6789", metadata: %{}, object: "bank_account",
      routing_number: "110000000", status: "new"}
    @update_attrs %{account_holder_name: "new_name", account_holder_type: "new_type"}
    @invalid_attrs %{id: nil}

    def bank_account_fixture() do
      {:ok, bank_account} = Repo.insert(@valid_struct)

      bank_account
    end

    test "list_bank_accounts/0 returns all bank_accounts" do
      bank_account = bank_account_fixture()
      assert Enum.any?(StripePaymentMethods.list_bank_accounts(), &(&1.id == bank_account.id))
    end

    test "get_bank_account!/1 returns the bank_account with given id" do
      bank_account = bank_account_fixture()
      get_bank_account = StripePaymentMethods.get_bank_account!(bank_account.id)
      assert get_bank_account.id == bank_account.id
    end

    test "create_bank_account/1 with valid data creates a bank_account" do
      assert {:ok, %BankAccount{}} = StripePaymentMethods.create_bank_account(@valid_attrs)
    end

    test "create_bank_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.create_bank_account(@invalid_attrs)
    end

    test "update_bank_account/2 with valid data updates the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = StripePaymentMethods.update_bank_account(bank_account, @update_attrs)
    end

    test "update_bank_account/2 with invalid data returns error changeset" do
      bank_account = bank_account_fixture()
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.update_bank_account(bank_account, @invalid_attrs)
    end

    test "delete_bank_account/1 deletes the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = StripePaymentMethods.delete_bank_account(bank_account)
      assert_raise Ecto.NoResultsError, fn -> StripePaymentMethods.get_bank_account!(bank_account.id) end
    end

    test "change_bank_account/1 returns a bank_account changeset" do
      bank_account = bank_account_fixture()
      assert %Ecto.Changeset{} = StripePaymentMethods.change_bank_account(bank_account)
    end
  end

  describe "cards" do
    alias Breakbench.StripePaymentMethods.Card

    @valid_struct card_factory()

    @valid_attrs %{id: "test_card", brand: "Visa", country: "au", customer: "test_customer",
      exp_month: 8, exp_year: 2019, fingerprint: "m9nJOqUqP8boDe0c", funding: "credit",
      last4: "4242", metadata: %{}, object: "card"}
    @update_attrs %{name: "new_name"}
    @invalid_attrs %{id: nil}

    def card_fixture() do
      {:ok, card} = Repo.insert(@valid_struct)

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Enum.any?(StripePaymentMethods.list_cards(), &(&1.id == card.id))
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      get_card = StripePaymentMethods.get_card!(card.id)
      assert get_card.id == card.id
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{}} = StripePaymentMethods.create_card(@valid_attrs)
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = StripePaymentMethods.update_card(card, @update_attrs)
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.update_card(card, @invalid_attrs)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = StripePaymentMethods.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> StripePaymentMethods.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = StripePaymentMethods.change_card(card)
    end
  end

  describe "sources" do
    alias Breakbench.StripePaymentMethods.Source

    @valid_struct source_factory()

    @valid_attrs %{id: "test_source", client_secret: "src_client_secret_CwjcOVbJVSfjA0oMnSUbzhk7",
      created: ~N[2018-05-28 16:54:17], currency: "aud", flow: "receiver", metadata: %{}, object: "source",
      status: "pending", type: "ach_credit_transfer", usage: "reusable", customer: "test_customer"}
    @update_attrs %{owner: %{email: "new.email@example.com", name: "new name"}}
    @invalid_attrs %{id: nil}

    def source_fixture() do
      {:ok, source} = Repo.insert(@valid_struct)

      source
    end

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert Enum.any?(StripePaymentMethods.list_sources(), &(&1.id == source.id))
    end

    test "get_source!/1 returns the source with given id" do
      source = source_fixture()
      get_source = StripePaymentMethods.get_source!(source.id)
      assert get_source.id == source.id
    end

    test "create_source/1 with valid data creates a source" do
      assert {:ok, %Source{}} = StripePaymentMethods.create_source(@valid_attrs)
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.create_source(@invalid_attrs)
    end

    test "update_source/2 with valid data updates the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = StripePaymentMethods.update_source(source, @update_attrs)
    end

    test "update_source/2 with invalid data returns error changeset" do
      source = source_fixture()
      assert {:error, %Ecto.Changeset{}} = StripePaymentMethods.update_source(source, @invalid_attrs)
    end

    test "delete_source/1 deletes the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = StripePaymentMethods.delete_source(source)
      assert_raise Ecto.NoResultsError, fn -> StripePaymentMethods.get_source!(source.id) end
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = StripePaymentMethods.change_source(source)
    end
  end
end
