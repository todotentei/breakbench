defmodule Breakbench.StripeTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  describe "accounts" do
    alias Breakbench.AccountStripe
    alias Breakbench.StripeConnect.Account

    # Data is optional in testing, as fake server will always return
    # a valid response.
    @valid_attrs %{country: "au", default_currency: "aud"}

    setup do
      # Make sure associations matching with fake server
      country = insert(:country, short_name: "au")
      currency = insert(:currency, code: "aud")

      {:ok, country: country, currency: currency}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeConnect
      {:ok, retrieve} = AccountStripe.retrieve("test_account")

      AccountStripe.async(retrieve)
      :sys.get_state(AccountStripe)

      account = StripeConnect.get_account!("test_account")
      assert account.country_short_name == context[:country].short_name
      assert account.default_currency_code == context[:currency].code
    end

    test "sync/1 returns a account", context do
      {:ok, retrieve} = AccountStripe.retrieve("test_account")
      # If account is new, create
      assert {:ok, %Account{} = account} = AccountStripe.sync(retrieve)

      assert account.country_short_name == context[:country].short_name
      assert account.default_currency_code == context[:currency].code

      # If account exists, return
      assert {:ok, %Account{}} = AccountStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a account", context do
      assert {:ok, %Account{} = account} = AccountStripe.create(@valid_attrs)

      assert account.country_short_name == context[:country].short_name
      assert account.default_currency_code == context[:currency].code
    end

    test "update/2 with valid attrs updates the account" do
      AccountStripe.create(@valid_attrs)
      assert {:ok, %Account{}} = AccountStripe.update("test_account", @valid_attrs)
    end
  end

  describe "account bank accounts" do
    alias Breakbench.Account.BankAccountStripe
    alias Breakbench.StripePaymentMethods.BankAccount

    @parent_id "test_account"
    @id "test_bank_account"

    @valid_attrs %{external_account: @id}
    @update_attrs %{account_holder_name: "update user"}

    setup do
      country = insert(:country, short_name: "au")
      currency = insert(:currency, code: "aud")
      account = insert(:account, id: @parent_id)

      {:ok, country: country, currency: currency, account: account}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripePaymentMethods
      {:ok, retrieve} = BankAccountStripe.retrieve(@parent_id, @id)

      BankAccountStripe.async(retrieve)
      :sys.get_state(BankAccountStripe)

      bank_account = StripePaymentMethods.get_bank_account!(@id)
      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.account_id == context[:account].id
    end

    test "sync/1 returns a bank account", context do
      {:ok, retrieve} = BankAccountStripe.retrieve(@parent_id, @id)
      # If bank_account is new, create
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.sync(retrieve)

      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.account_id == context[:account].id

      # If bank_account exists, return
      assert {:ok, %BankAccount{}} = BankAccountStripe.sync(retrieve)
    end

    test "create/2 with valid attrs returns a bank account", context do
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.create(@parent_id, @valid_attrs)

      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.account_id == context[:account].id
    end

    test "create/1 with default_for_currency true set others to false" do
      alias Breakbench.StripePaymentMethods
      alias Breakbench.Account.CardStripe
      alias Breakbench.StripePaymentMethods.Card

      insert(:currency, code: "usd")
      # Note: currency can't be used directly outside test env
      BankAccountStripe.create(@parent_id, %{external_account: "usd_bank_account", default_for_currency: true, currency: "usd"})

      assert {:ok, %Card{default_for_currency: true}} = CardStripe.create(@parent_id,
        %{external_account: "test_card", default_for_currency: true})

      assert {:ok, %BankAccount{default_for_currency: true}} = BankAccountStripe.create(@parent_id,
        %{external_account: @id, default_for_currency: true})
      assert %Card{default_for_currency: false} = StripePaymentMethods.get_card!("test_card")

      assert {:ok, %BankAccount{default_for_currency: true}} = BankAccountStripe.create(@parent_id,
        %{external_account: "new_bank_account", default_for_currency: true})
      assert %BankAccount{default_for_currency: false} = StripePaymentMethods.get_bank_account!(@id)
      assert %Card{default_for_currency: false} = StripePaymentMethods.get_card!("test_card")

      assert %BankAccount{default_for_currency: true} = StripePaymentMethods.get_bank_account!("usd_bank_account")
    end

    test "update/3 with valid attrs updates the bank account" do
      BankAccountStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.update(@parent_id, @id, @update_attrs)

      assert bank_account.account_holder_name == @update_attrs.account_holder_name
    end

    test "delete/2 returns a deleted bank account" do
      BankAccountStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %BankAccount{}} = BankAccountStripe.delete(@parent_id, @id)
      assert_raise Ecto.NoResultsError, fn -> Breakbench.StripePaymentMethods.get_bank_account!(@id) end
    end
  end

  describe "account cards" do
    alias Breakbench.Account.CardStripe
    alias Breakbench.StripePaymentMethods.Card

    @parent_id "test_account"
    @id "test_card"

    @valid_attrs %{external_account: @id}
    @update_attrs %{name: "update user"}

    setup do
      country = insert(:country, short_name: "au")
      currency = insert(:currency, code: "aud")
      account = insert(:account, id: @parent_id)

      {:ok, country: country, currency: currency, account: account}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripePaymentMethods
      {:ok, retrieve} = CardStripe.retrieve(@parent_id, @id)

      CardStripe.async(retrieve)
      :sys.get_state(CardStripe)

      card = StripePaymentMethods.get_card!(@id)
      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.account_id == context[:account].id
    end

    test "sync/1 returns a card", context do
      {:ok, retrieve} = CardStripe.retrieve(@parent_id, @id)
      # If card is new, create
      assert {:ok, %Card{} = card} = CardStripe.sync(retrieve)

      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.account_id == context[:account].id

      # If card exists, return
      assert {:ok, %Card{}} = CardStripe.sync(retrieve)
    end

    test "create/2 with valid attrs returns a card", context do
      assert {:ok, %Card{} = card} = CardStripe.create(@parent_id, @valid_attrs)

      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.account_id == context[:account].id
    end

    test "create/1 with default_for_currency true set others to false" do
      alias Breakbench.StripePaymentMethods
      alias Breakbench.Account.BankAccountStripe
      alias Breakbench.StripePaymentMethods.BankAccount

      insert(:currency, code: "usd")
      # Note: currency can't be used directly outside test env
      CardStripe.create(@parent_id, %{external_account: "usd_card", default_for_currency: true, currency: "usd"})

      assert {:ok, %BankAccount{default_for_currency: true}} = BankAccountStripe.create(@parent_id,
        %{external_account: "test_bank_account", default_for_currency: true})

      assert {:ok, %Card{default_for_currency: true}} = CardStripe.create(@parent_id,
        %{external_account: @id, default_for_currency: true})
      assert %BankAccount{default_for_currency: false} = StripePaymentMethods.get_bank_account!("test_bank_account")

      assert {:ok, %Card{default_for_currency: true}} = CardStripe.create(@parent_id,
        %{external_account: "new_card", default_for_currency: true})
      assert %Card{default_for_currency: false} = StripePaymentMethods.get_card!(@id)
      assert %BankAccount{default_for_currency: false} = StripePaymentMethods.get_bank_account!("test_bank_account")

      assert %Card{default_for_currency: true} = StripePaymentMethods.get_card!("usd_card")
    end

    test "update/3 with valid attrs updates the card" do
      CardStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %Card{} = card} = CardStripe.update(@parent_id, @id, @update_attrs)

      assert card.name == @update_attrs.name
    end

    test "delete/2 returns a deleted card" do
      CardStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %Card{}} = CardStripe.delete(@parent_id, @id)
      assert_raise Ecto.NoResultsError, fn -> Breakbench.StripePaymentMethods.get_card!(@id) end
    end
  end

  describe "balance_transactions" do
    alias Breakbench.BalanceTransactionStripe
    alias Breakbench.StripeResources.BalanceTransaction

    setup do
      currency = insert(:currency, code: "aud")

      {:ok, currency: currency}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeResources
      {:ok, retrieve} = BalanceTransactionStripe.retrieve("test_balance_transaction")

      BalanceTransactionStripe.async(retrieve)
      :sys.get_state(BalanceTransactionStripe)

      balance_transaction = StripeResources.get_balance_transaction!("test_balance_transaction")
      assert balance_transaction.currency_code == context[:currency].code
    end

    test "sync/1 returns a balance_transaction", context do
      {:ok, retrieve} = BalanceTransactionStripe.retrieve("test_balance_transaction")
      # If balance_transaction is new, create
      assert {:ok, %BalanceTransaction{} = balance_transaction} =
        BalanceTransactionStripe.sync(retrieve)

      assert balance_transaction.currency == context[:currency]

      # If balance_transaction exists, return
      assert {:ok, %BalanceTransaction{}} =
        BalanceTransactionStripe.sync(retrieve)
    end
  end

  describe "charges" do
    alias Breakbench.ChargeStripe
    alias Breakbench.StripeResources.Charge

    @valid_attrs %{currency: "aud", balance_transaction: "test_balance_transaction",
      customer: "test_customer", destination: "test_account", on_behalf_of: "test_account",
      source_transfer: "test_transfer", transfer: "test_transfer"}

    setup do
      currency = insert(:currency, code: "aud")
      balance_transaction = insert(:balance_transaction, id: "test_balance_transaction")
      customer = insert(:customer, id: "test_customer")
      account = insert(:account, id: "test_account")
      transfer = insert(:transfer, id: "test_transfer")

      {:ok, currency: currency, balance_transaction: balance_transaction,
        customer: customer, account: account, transfer: transfer}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeResources
      {:ok, retrieve} = ChargeStripe.retrieve("test_charge")

      ChargeStripe.async(retrieve)
      :sys.get_state(ChargeStripe)

      charge = StripeResources.get_charge!("test_charge")
      assert charge.currency_code == context[:currency].code
      assert charge.balance_transaction_id == context[:balance_transaction].id
      assert charge.customer_id == context[:customer].id
      assert charge.destination_id == context[:account].id
      assert charge.on_behalf_of_id == context[:account].id
      assert charge.source_transfer_id == context[:transfer].id
      assert charge.transfer_id == context[:transfer].id
    end

    test "sync/1 returns a charge", context do
      {:ok, retrieve} = ChargeStripe.retrieve("test_charge")
      # If charge is new, create
      assert {:ok, %Charge{} = charge} = ChargeStripe.sync(retrieve)

      assert charge.currency_code == context[:currency].code
      assert charge.balance_transaction_id == context[:balance_transaction].id
      assert charge.customer_id == context[:customer].id
      assert charge.destination_id == context[:account].id
      assert charge.on_behalf_of_id == context[:account].id
      assert charge.source_transfer_id == context[:transfer].id
      assert charge.transfer_id == context[:transfer].id

      # If charge exists, return
      assert {:ok, %Charge{}} = ChargeStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a charge", context do
      assert {:ok, %Charge{} = charge} = ChargeStripe.create(@valid_attrs)

      assert charge.currency_code == context[:currency].code
      assert charge.balance_transaction_id == context[:balance_transaction].id
      assert charge.customer_id == context[:customer].id
      assert charge.destination_id == context[:account].id
      assert charge.on_behalf_of_id == context[:account].id
      assert charge.source_transfer_id == context[:transfer].id
      assert charge.transfer_id == context[:transfer].id
    end

    test "update/2 with valid attrs updates the charge" do
      ChargeStripe.create(@valid_attrs)
      assert {:ok, %Charge{}} = ChargeStripe.update("test_charge", @valid_attrs)
    end
  end

  describe "customers" do
    alias Breakbench.CustomerStripe
    alias Breakbench.StripeResources.Customer

    @valid_attrs %{currency: "aud"}

    setup do
      currency = insert(:currency, code: "aud")

      {:ok, currency: currency}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeResources
      {:ok, retrieve} = CustomerStripe.retrieve("test_customer")

      CustomerStripe.async(retrieve)
      :sys.get_state(CustomerStripe)

      customer = StripeResources.get_customer!("test_customer")
      assert customer.currency_code == context[:currency].code
    end

    test "sync/1 returns a customer", context do
      {:ok, retrieve} = CustomerStripe.retrieve("test_customer")
      # If customer is new, create
      assert {:ok, %Customer{} = customer} = CustomerStripe.sync(retrieve)

      assert customer.currency_code == context[:currency].code

      # If customer exists, return
      assert {:ok, %Customer{}} = CustomerStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a customer", context do
      assert {:ok, %Customer{} = customer} = CustomerStripe.create(@valid_attrs)

      assert customer.currency_code == context[:currency].code
    end

    test "update/2 with valid attrs updates the customer" do
      CustomerStripe.create(@valid_attrs)
      assert {:ok, %Customer{}} = CustomerStripe.update("test_customer", @valid_attrs)
    end
  end

  describe "customer cards" do
    alias Breakbench.Customer.CardStripe
    alias Breakbench.StripePaymentMethods.Card

    @parent_id "test_customer"
    @id "test_card"

    @valid_attrs %{source: @id}
    @update_attrs %{name: "update user"}

    setup do
      country = insert(:country, short_name: "au")
      currency = insert(:currency, code: "aud")
      customer = insert(:customer, id: @parent_id)

      {:ok, country: country, currency: currency, customer: customer}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripePaymentMethods
      {:ok, retrieve} = CardStripe.retrieve(@parent_id, @id)

      CardStripe.async(retrieve)
      :sys.get_state(CardStripe)

      card = StripePaymentMethods.get_card!(@id)
      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.customer_id == context[:customer].id
    end

    test "sync/1 returns a card", context do
      {:ok, retrieve} = CardStripe.retrieve(@parent_id, @id)
      # If card is new, create
      assert {:ok, %Card{} = card} = CardStripe.sync(retrieve)

      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.customer_id == context[:customer].id

      # If card exists, return
      assert {:ok, %Card{}} = CardStripe.sync(retrieve)
    end

    test "create/2 with valid attrs returns a card", context do
      assert {:ok, %Card{} = card} = CardStripe.create(@parent_id, @valid_attrs)

      assert card.country_short_name == context[:country].short_name
      assert card.currency_code == context[:currency].code
      assert card.customer_id == context[:customer].id
    end

    test "update/3 with valid attrs updates the card" do
      CardStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %Card{} = card} = CardStripe.update(@parent_id, @id, @update_attrs)

      assert card.name == @update_attrs.name
    end

    test "delete/2 returns a deleted card" do
      CardStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %Card{}} = CardStripe.delete(@parent_id, @id)
      assert_raise Ecto.NoResultsError, fn -> Breakbench.StripePaymentMethods.get_card!(@id) end
    end
  end

  describe "customer bank accounts" do
    alias Breakbench.Customer.BankAccountStripe
    alias Breakbench.StripePaymentMethods.BankAccount

    @parent_id "test_customer"
    @id "test_bank_account"

    @valid_attrs %{source: @id}
    @update_attrs %{account_holder_name: "update user"}
    @verify_attrs %{amounts: [32, 45]}

    setup do
      country = insert(:country, short_name: "au")
      currency = insert(:currency, code: "aud")
      customer = insert(:customer, id: @parent_id)

      {:ok, country: country, currency: currency, customer: customer}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripePaymentMethods
      {:ok, retrieve} = BankAccountStripe.retrieve(@parent_id, @id)

      BankAccountStripe.async(retrieve)
      :sys.get_state(BankAccountStripe)

      bank_account = StripePaymentMethods.get_bank_account!(@id)
      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.customer_id == context[:customer].id
    end

    test "sync/1 returns a bank account", context do
      {:ok, retrieve} = BankAccountStripe.retrieve(@parent_id, @id)
      # If bank_account is new, create
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.sync(retrieve)

      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.customer_id == context[:customer].id

      # If bank_account exists, return
      assert {:ok, %BankAccount{}} = BankAccountStripe.sync(retrieve)
    end

    test "create/2 with valid attrs returns a bank account", context do
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.create(@parent_id, @valid_attrs)

      assert bank_account.country_short_name == context[:country].short_name
      assert bank_account.currency_code == context[:currency].code
      assert bank_account.customer_id == context[:customer].id
    end

    test "update/3 with valid attrs updates the bank account" do
      BankAccountStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.update(@parent_id, @id, @update_attrs)

      assert bank_account.account_holder_name == @update_attrs.account_holder_name
    end

    test "delete/2 returns a deleted bank account" do
      BankAccountStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %BankAccount{}} = BankAccountStripe.delete(@parent_id, @id)
      assert_raise Ecto.NoResultsError, fn -> Breakbench.StripePaymentMethods.get_bank_account!(@id) end
    end

    test "verify/3 returns an verified bank account" do
      BankAccountStripe.create(@parent_id, @valid_attrs)
      assert {:ok, %BankAccount{} = bank_account} = BankAccountStripe.verify(@parent_id, @id, @verify_attrs)

      assert bank_account.status == "verified"
    end
  end

  describe "customer sources" do
    alias Breakbench.Customer
    alias Breakbench.SourceStripe
    alias Breakbench.StripePaymentMethods.Source

    @valid_attrs %{currency: "aud", customer: "test_customer"}

    setup do
      currency = insert(:currency, code: "aud")
      customer = insert(:customer, id: "test_customer")

      {:ok, currency: currency, customer: customer}
    end

    test "attach/2 returns a source", context do
      SourceStripe.create(@valid_attrs)
      assert {:ok, %Source{} = source} = Customer.SourceStripe.attach("test_customer", %{source: "test_source"})

      assert source.customer_id == context[:customer].id
    end

    test "detach/2 return a source" do
      SourceStripe.create(@valid_attrs)
      assert {:ok, %Source{} = source} = Customer.SourceStripe.detach("test_customer", "test_source")

      assert source.status == "consumed"
    end
  end

  describe "payouts" do
    alias Breakbench.PayoutStripe
    alias Breakbench.StripeResources.Payout

    @valid_attrs %{currency: "aud", balance_transaction: "test_balance_transaction"}

    setup do
      currency = insert(:currency, code: "aud")
      balance_transaction = insert(:balance_transaction, id: "test_balance_transaction")

      {:ok, currency: currency, balance_transaction: balance_transaction}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeResources
      {:ok, retrieve} = PayoutStripe.retrieve("test_payout")

      PayoutStripe.async(retrieve)
      :sys.get_state(PayoutStripe)

      payout = StripeResources.get_payout!("test_payout")
      assert payout.currency_code == context[:currency].code
      assert payout.balance_transaction_id == context[:balance_transaction].id
    end

    test "sync/1 returns a payout", context do
      {:ok, retrieve} = PayoutStripe.retrieve("test_payout")
      # If payout is new, create
      assert {:ok, %Payout{} = payout} = PayoutStripe.sync(retrieve)

      assert payout.currency_code == context[:currency].code
      assert payout.balance_transaction_id == context[:balance_transaction].id

      # If payout exists, return
      assert {:ok, %Payout{}} = PayoutStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a payout", context do
      assert {:ok, %Payout{} = payout} = PayoutStripe.create(@valid_attrs)

      assert payout.currency_code == context[:currency].code
      assert payout.balance_transaction_id == context[:balance_transaction].id
    end

    test "update/2 with valid attrs updates the payout" do
      PayoutStripe.create(@valid_attrs)
      assert {:ok, %Payout{}} = PayoutStripe.update("test_payout", @valid_attrs)
    end

    test "cancel/1 returns a payout attrs" do
      assert {:ok, %{id: "test_payout"}} = PayoutStripe.cancel("test_payout")
    end
  end

  describe "refunds" do
    alias Breakbench.RefundStripe
    alias Breakbench.StripeResources.Refund

    @valid_attrs %{charge: "test_charge", currency: "aud"}

    setup do
      charge = insert(:charge, id: "test_charge")
      currency = insert(:currency, code: "aud")

      {:ok, charge: charge, currency: currency}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeResources
      {:ok, retrieve} = RefundStripe.retrieve("test_refund")

      RefundStripe.async(retrieve)
      :sys.get_state(RefundStripe)

      refund = StripeResources.get_refund!("test_refund")
      assert refund.charge_id == context[:charge].id
      assert refund.currency_code == context[:currency].code
    end

    test "sync/1 returns a refund", context do
      {:ok, retrieve} = RefundStripe.retrieve("test_refund")
      # If refund is new, create
      assert {:ok, %Refund{} = refund} = RefundStripe.sync(retrieve)

      assert refund.charge_id == context[:charge].id
      assert refund.currency_code == context[:currency].code

      # If refund exists, return
      assert {:ok, %Refund{}} = RefundStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a refund", context do
      assert {:ok, %Refund{} = refund} = RefundStripe.create(@valid_attrs)

      assert refund.charge_id == context[:charge].id
      assert refund.currency_code == context[:currency].code
    end

    test "update/2 with valid attrs updates the refund" do
      RefundStripe.create(@valid_attrs)
      assert {:ok, %Refund{}} = RefundStripe.update("test_refund", @valid_attrs)
    end
  end

  describe "sources" do
    alias Breakbench.Customer
    alias Breakbench.SourceStripe
    alias Breakbench.StripePaymentMethods.Source

    @valid_attrs %{currency: "aud", customer: "test_customer"}

    setup do
      currency = insert(:currency, code: "aud")
      customer = insert(:customer, id: "test_customer")

      {:ok, currency: currency, customer: customer}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripePaymentMethods
      {:ok, retrieve} = SourceStripe.retrieve("test_source")

      SourceStripe.async(retrieve)
      :sys.get_state(SourceStripe)

      source = StripePaymentMethods.get_source!("test_source")
      assert source.currency_code == context[:currency].code
      assert source.customer_id == context[:customer].id
    end

    test "sync/1 returns a source", context do
      {:ok, retrieve} = SourceStripe.retrieve("test_source")
      # If source is new, create
      assert {:ok, %Source{} = source} = SourceStripe.sync(retrieve)

      assert source.currency_code == context[:currency].code
      assert source.customer_id == context[:customer].id

      # if source exists, return
      assert {:ok, %Source{}} = SourceStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a source", context do
      assert {:ok, %Source{} = source} = SourceStripe.create(@valid_attrs)

      assert source.currency_code == context[:currency].code
      assert source.customer_id == context[:customer].id
    end

    test "update/2 with valid attrs updates the source" do
      SourceStripe.create(@valid_attrs)
      assert {:ok, %Source{}} = SourceStripe.update("test_source", @valid_attrs)
    end
  end

  describe "transfers" do
    alias Breakbench.TransferStripe
    alias Breakbench.StripeConnect.Transfer

    @valid_attrs %{balance_transaction: "test_balance_transaction", destination: "test_account",
      source_transaction: "test_charge"}

    setup do
      currency = insert(:currency, code: "aud")
      balance_transaction = insert(:balance_transaction, id: "test_balance_transaction")
      account = insert(:account, id: "test_account")
      charge = insert(:charge, id: "test_charge")

      {:ok, currency: currency, balance_transaction: balance_transaction,
        account: account, charge: charge}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeConnect
      {:ok, retrieve} = TransferStripe.retrieve("test_transfer")

      TransferStripe.async(retrieve)
      :sys.get_state(TransferStripe)

      transfer = StripeConnect.get_transfer!("test_transfer")
      assert transfer.currency_code == context[:currency].code
      assert transfer.balance_transaction_id == context[:balance_transaction].id
      assert transfer.destination_id == context[:account].id
      assert transfer.source_transaction_id == context[:charge].id
    end

    test "sync/1 returns a transfer", context do
      {:ok, retrieve} = TransferStripe.retrieve("test_transfer")
      # If transfer is new, create
      assert {:ok, %Transfer{} = transfer} = TransferStripe.sync(retrieve)

      assert transfer.currency_code == context[:currency].code
      assert transfer.balance_transaction_id == context[:balance_transaction].id
      assert transfer.destination_id == context[:account].id
      assert transfer.source_transaction_id == context[:charge].id

      # If transfer exists, return
      assert {:ok, %Transfer{}} = TransferStripe.sync(retrieve)
    end

    test "create/1 with valid attrs returns a transfer", context do
      assert {:ok, %Transfer{} = transfer} = TransferStripe.create(@valid_attrs)

      assert transfer.currency_code == context[:currency].code
      assert transfer.balance_transaction_id == context[:balance_transaction].id
      assert transfer.destination_id == context[:account].id
      assert transfer.source_transaction_id == context[:charge].id
    end

    test "update/2 with valid attrs updates the transfer" do
      TransferStripe.create(@valid_attrs)
      assert {:ok, %Transfer{}} = TransferStripe.update("test_transfer", @valid_attrs)
    end
  end

  describe "transfer_reversals" do
    alias Breakbench.TransferReversalStripe
    alias Breakbench.StripeConnect.TransferReversal

    @valid_attrs %{currency: "aud", balance_transaction: "test_balance_transaction",
      transfer: "test_transfer"}

    setup do
      currency = insert(:currency, code: "aud")
      balance_transaction = insert(:balance_transaction, id: "test_balance_transaction")
      transfer = insert(:transfer, id: "test_transfer")

      {:ok, currency: currency, balance_transaction: balance_transaction, transfer: transfer}
    end

    test "async/1 solves all associations", context do
      alias Breakbench.StripeConnect
      {:ok, retrieve} = TransferReversalStripe.retrieve("test_transfer", "test_transfer_reversal")

      TransferReversalStripe.async(retrieve)
      :sys.get_state(TransferReversalStripe)

      transfer_reversal = StripeConnect.get_transfer_reversal!("test_transfer_reversal")
      assert transfer_reversal.currency_code == context[:currency].code
      assert transfer_reversal.balance_transaction_id == context[:balance_transaction].id
      assert transfer_reversal.transfer_id == context[:transfer].id
    end

    test "sync/1 returns a transfer reversal", context do
      {:ok, retrieve} = TransferReversalStripe.retrieve("test_transfer", "test_transfer_reversal")
      # If transfer reversal is new, create
      assert {:ok, %TransferReversal{} = transfer_reversal} = TransferReversalStripe.sync(retrieve)

      assert transfer_reversal.currency_code == context[:currency].code
      assert transfer_reversal.balance_transaction_id == context[:balance_transaction].id
      assert transfer_reversal.transfer_id == context[:transfer].id

      # If transfer reverse exists, return
      assert {:ok, %TransferReversal{}} = TransferReversalStripe.sync(retrieve)
    end

    test "create/2 with valid attrs returns a transfer reversal", context do
      assert {:ok, %TransferReversal{} = transfer_reversal} = TransferReversalStripe.create("test_transfer", @valid_attrs)

      assert transfer_reversal.currency_code == context[:currency].code
      assert transfer_reversal.balance_transaction_id == context[:balance_transaction].id
      assert transfer_reversal.transfer_id == context[:transfer].id
    end

    test "update/3 with valid attrs updates the transfer reverse" do
      TransferReversalStripe.create("test_transfer", @valid_attrs)
      assert {:ok, %TransferReversal{}} = TransferReversalStripe.update("test_transfer", "test_transfer_reversal", @valid_attrs)
    end
  end
end
