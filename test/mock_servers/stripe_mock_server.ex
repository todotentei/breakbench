defmodule Breakbench.StripeMockServer do
  use Breakbench.MockServer

  record :account, [
    id: "test_account",
    object: "account",
    business_name: "Stripe.com",
    charges_enabled: false,
    country: "au",
    created: 1528105469,
    default_currency: "aud",
    details_submitted: false,
    display_name: "Stripe.com",
    email: "site@stripe.com",
    metadata: %{},
    payouts_enabled: false,
    statement_descriptor: "",
    timezone: "US/Pacific",
    type: "standard"
  ]

  record :account_bank_account, [
    id: "test_bank_account",
    account: "test_account",
    account_holder_name: "Jane Austen",
    account_holder_type: "individual",
    bank_name: "STRIPE TEST BANK",
    country: "au",
    currency: "aud",
    default_for_currency: false,
    fingerprint: "1JWtPxqbdX5Gamtc",
    last4: "6789",
    metadata: %{},
    object: "bank_account",
    routing_number: "110000000",
    status: "new"
  ]

  record :account_card, [
    id: "test_card",
    account: "test_account",
    brand: "Visa",
    country: "au",
    currency: "aud",
    cvc_check: nil,
    default_for_currency: false,
    dynamic_last4: nil,
    exp_month: 8,
    exp_year: 2019,
    fingerprint: "Xt5EWLLDS7FJjR1c",
    funding: "debit",
    last4: "4242",
    metadata: %{},
    name: nil,
    object: "card",
    tokenization_method: nil
  ]

  record :balance_transaction, [
    id: "test_balance_transaction",
    object: "balance_transaction",
    amount: 100,
    available_on: 1527526457,
    created: 1527526457,
    currency: "aud",
    fee: 0,
    fee_details: [],
    net: 100,
    status: "pending",
    type: "charge"
  ]

  record :charge, [
    id: "test_charge",
    metadata: %{},
    currency: "aud",
    balance_transaction: "test_balance_transaction",
    customer: "test_customer",
    destination: "test_account",
    description: "My First Test Charge (created for API docs)",
    refunded: false,
    fraud_details: %{},
    on_behalf_of: "test_account",
    paid: true,
    created: 1527526457,
    amount_refunded: 0,
    captured: false,
    source_transfer: "test_transfer",
    transfer: "test_transfer",
    amount: 100,
    object: "charge",
    status: "succeeded"
  ]

  record :customer, [
    id: "test_customer",
    object: "customer",
    account_balance: 0,
    created: 1528105469,
    currency: "aud",
    delinquent: false,
    description: nil,
    email: nil,
    invoice_prefix: "1AD93B5",
    metadata: %{},
    shipping: %{}
  ]

  record :customer_bank_account, [
    id: "test_bank_account",
    customer: "test_customer",
    account_holder_name: "Jane Austen",
    account_holder_type: "individual",
    bank_name: "STRIPE TEST BANK",
    country: "au",
    currency: "aud",
    fingerprint: "1JWtPxqbdX5Gamtc",
    last4: "6789",
    metadata: %{},
    object: "bank_account",
    routing_number: "110000000",
    status: "new"
  ]

  record :customer_card, [
    id: "test_card",
    brand: "Visa",
    country: "au",
    currency: "aud",
    customer: "test_customer",
    cvc_check: nil,
    dynamic_last4: nil,
    exp_month: 8,
    exp_year: 2019,
    fingerprint: "Xt5EWLLDS7FJjR1c",
    funding: "credit",
    last4: "4242",
    metadata: %{},
    name: nil,
    object: "card",
    tokenization_method: nil
  ]

  record :payout, [
    id: "test_payout",
    amount: 5687,
    arrival_date: 1386374400,
    automatic: true,
    balance_transaction: "test_balance_transaction",
    created: 1386212146,
    currency: "aud",
    description: "STRIPE TRANSFER",
    destination: nil,
    failure_balance_transaction: nil,
    failure_code: nil,
    failure_message: nil,
    metadata: %{order_id: "6735"},
    method: "standard",
    object: "payout",
    source_type: "card",
    statement_descriptor: nil,
    status: "paid",
    type: "bank_account"
  ]

  record :refund, [
    id: "test_refund",
    balance_transaction: "test_balance_transaction",
    charge: "test_charge",
    currency: "aud",
    amount: 100,
    created: 1527532373,
    metadata: %{},
    object: "refund",
    status: "succeeded"
  ]

  record :source, [
    id: "test_source",
    ach_credit_transfer: %{
      account_number: "test_52796e3294dc",
      bank_name: "TEST BANK",
      fingerprint: nil,
      routing_number: "110000000",
      swift_code: "TSTEZ122"
    },
    amount: nil,
    client_secret: "src_client_secret_D40ladVvR12QLOjguFzzHTbm",
    created: 1529210601,
    currency: "aud",
    flow: "receiver",
    metadata: %{},
    object: "source",
    owner: %{
      address: nil,
      email: "jenny.rosen@example.com",
      name: nil,
      phone: nil,
      verified_address: nil,
      verified_email: nil,
      verified_name: nil,
      verified_phone: nil
    },
    receiver: %{
      address: "121042882-38381234567890123",
      amount_charged: 0,
      amount_received: 0,
      amount_returned: 0,
      refund_attributes_method: "email",
      refund_attributes_status: "missing"
    },
    statement_descriptor: nil,
    status: "pending",
    type: "ach_credit_transfer",
    usage: "reusable",
    customer: "test_customer"
  ]

  record :transfer, [
    id: "test_transfer",
    amount: 1100,
    amount_reversed: 0,
    balance_transaction: "test_balance_transaction",
    created: 1527532373,
    currency: "aud",
    destination: "test_account",
    destination_payment: "py_Cwjc8bexq2WYfz",
    metadata: %{},
    object: "transfer",
    reversed: false,
    source_transaction: "test_charge",
    source_type: "card",
    transfer_group: nil
  ]

  record :transfer_reversal, [
    id: "test_transfer_reversal",
    object: "transfer_reversal",
    amount: 400,
    balance_transaction: "test_balance_transaction",
    created: 1527532373,
    currency: "aud",
    metadata: %{},
    transfer: "test_transfer"
  ]


  ## Accounts

  def request(:get, "accounts/test_account/external_accounts/test_bank_account", %{}) do
    {:ok, account_bank_account()}
  end

  def request(:get, "accounts/test_account/external_accounts/test_card", %{}) do
    {:ok, account_card()}
  end

  def request(:post, "accounts/test_account/external_accounts/test_bank_account", data) do
    {:ok, account_bank_account(data)}
  end

  def request(:post, "accounts/test_account/external_accounts/test_card", data) do
    {:ok, account_card(data)}
  end

  def request(:delete, "accounts/test_account/external_accounts/test_bank_account", %{}) do
    {:ok, %{id: "test_bank_account", deleted: true}}
  end

  def request(:delete, "accounts/test_account/external_accounts/test_card", %{}) do
    {:ok, %{id: "test_card", deleted: true}}
  end

  def request(:post, "accounts/test_account/external_accounts", %{external_account: ea} = data)
      when ea in ["test_bank_account", "new_bank_account", "usd_bank_account"] do
    {:ok, account_bank_account(Map.merge(data, %{id: ea}))}
  end

  def request(:post, "accounts/test_account/external_accounts", %{external_account: ea} = data)
      when ea in ["test_card", "new_card", "usd_card"] do
    {:ok, account_card(Map.merge(data, %{id: ea}))}
  end

  def request(:post, "accounts", data) do
    {:ok, account(data)}
  end

  def request(:get, "accounts/" <> id, %{}) do
    {:ok, account(id: id)}
  end

  def request(:post, "accounts/" <> id, data) do
    {:ok, account(Map.merge(data, %{id: id}))}
  end

  def request(:delete, "accounts/test_account", %{}) do
    {:ok, %{id: "test_account", deleted: true}}
  end

  def request(:post, "accounts/test_account/reject", %{reason: "fraud"}) do
    {:ok, put_in(account(), [:verification],
      %{disabled_reason: "rejected.fraud"})}
  end


  ## Balance Transactions

  def request(:get, "balance/history/" <> id, %{}) do
    {:ok, balance_transaction(id: id)}
  end


  ## Charges

  def request(:post, "charges", data) do
    {:ok, charge(data)}
  end

  def request(:get, "charges/" <> id, %{}) do
    {:ok, charge(id: id)}
  end

  def request(:post, "charges/" <> id, data) do
    {:ok, charge(Map.merge(data, %{id: id}))}
  end


  ## Customers

  def request(:get, "customers/test_customer/sources/test_bank_account", %{}) do
    {:ok, customer_bank_account()}
  end

  def request(:get, "customers/test_customer/sources/test_card", %{}) do
    {:ok, customer_card()}
  end

  def request(:post, "customers/test_customer/sources/test_bank_account/verify", %{}) do
    {:ok, customer_bank_account(%{status: "verified"})}
  end

  def request(:post, "customers/test_customer/sources/test_bank_account", data) do
    {:ok, customer_bank_account(data)}
  end

  def request(:post, "customers/test_customer/sources/test_card", data) do
    {:ok, customer_card(data)}
  end

  def request(:delete, "customers/test_customer/sources/test_bank_account", %{}) do
    {:ok, %{id: "test_bank_account", deleted: true}}
  end

  def request(:delete, "customers/test_customer/sources/test_card", %{}) do
    {:ok, %{id: "test_card", deleted: true}}
  end

  def request(:delete, "customers/test_customer/sources/test_source", %{}) do
    {:ok, source(id: "test_source", status: "consumed")}
  end

  def request(:post, "customers/test_customer/sources", %{source: "test_source"}) do
    {:ok, source()}
  end

  def request(:post, "customers/test_customer/sources", %{source: "test_bank_account"}) do
    {:ok, customer_bank_account()}
  end

  def request(:post, "customers/test_customer/sources", %{source: "test_card"}) do
    {:ok, customer_card()}
  end

  def request(:post, "customers", %{}) do
    {:ok, customer()}
  end

  def request(:get, "customers/test_customer", %{}) do
    {:ok, customer()}
  end

  def request(:post, "customers/test_customer", data) do
    {:ok, customer(data)}
  end

  def request(:delete, "customers/test_customer", %{}) do
    {:ok, %{id: "test_customer", deleted: true}}
  end


  ## Payouts

  def request(:post, "payouts", %{}) do
    {:ok, payout()}
  end

  def request(:get, "payouts/" <> id, %{}) do
    {:ok, payout(id: id)}
  end

  def request(:post, "payouts/test_payout/cancel", %{}) do
    {:ok, payout()}
  end

  def request(:post, "payouts/" <> id, data) do
    {:ok, payout(Map.merge(data, %{id: id}))}
  end


  ## Refunds

  def request(:post, "refunds", %{}) do
    {:ok, refund()}
  end

  def request(:get, "refunds/" <> id, %{}) do
    {:ok, refund(id: id)}
  end

  def request(:post, "refunds/" <> id, data) do
    {:ok, refund(Map.merge(data, %{id: id}))}
  end


  ## Sources

  def request(:post, "sources", %{}) do
    {:ok, source()}
  end

  def request(:get, "sources/test_source", %{}) do
    {:ok, source()}
  end

  def request(:post, "sources/test_source", data) do
    {:ok, source(data)}
  end


  ## Transfer Reversals

  def request(:post, "transfers/test_transfer/reversals", %{}) do
    {:ok, transfer_reversal()}
  end

  def request(:get, "transfers/test_transfer/reversals/" <> id, %{}) do
    {:ok, transfer_reversal(id: id)}
  end

  def request(:post, "transfers/test_transfer/reversals/" <> id, data) do
    {:ok, transfer_reversal(Map.merge(data, %{id: id}))}
  end


  ## Transfers

  def request(:post, "transfers", %{}) do
    {:ok, transfer()}
  end

  def request(:get, "transfers/" <> id, %{}) do
    {:ok, transfer(id: id)}
  end

  def request(:post, "transfers/" <> id, data) do
    {:ok, transfer(Map.merge(data, %{id: id}))}
  end
end
