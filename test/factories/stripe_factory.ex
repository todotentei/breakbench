defmodule Breakbench.StripeFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.StripeConnect.{
        Account, Transfer, TransferReversal
      }
      alias Breakbench.StripeResources.{
        Customer, BalanceTransaction, Charge, Refund, Payout
      }
      alias Breakbench.StripePaymentMethods.{
        BankAccount, Card, Source
      }

      def account_factory do
        %Account{
          id: sequence(:id, &"test_account#{&1}"),
          object: "account",
          business_name: "Stripe.com",
          charges_enabled: false,
          country: build(:country),
          default_currency: build(:currency),
          details_submitted: false,
          display_name: "Stripe.com",
          email: "site@stripe.com",
          metadata: %{},
          payouts_enabled: false,
          statement_descriptor: "",
          timezone: "US/Pacific",
          type: "standard"
        }
      end

      def customer_factory do
        %Customer{
          id: sequence(:id, &"test_customer#{&1}"),
          object: "customer",
          account_balance: 0,
          created: ~N[2018-05-28 18:32:44],
          currency: build(:currency),
          delinquent: false,
          invoice_prefix: "51B0154",
          metadata: %{}
        }
      end

      def balance_transaction_factory do
        %BalanceTransaction{
          id: sequence(:id, &"test_balance_transaction#{&1}"),
          object: "balance_transaction",
          amount: 100,
          available_on: ~N[2018-05-28 16:54:17],
          created: ~N[2018-05-28 16:54:17],
          currency: build(:currency),
          fee: 0,
          fee_details: [],
          net: 100,
          status: "pending",
          type: "charge"
        }
      end

      def charge_factory do
        %Charge{
          id: sequence(:id, &"test_charge#{&1}"),
          metadata: %{},
          currency: build(:currency),
          balance_transaction: build(:balance_transaction),
          customer: build(:customer),
          destination: build(:account),
          description: "My First Test Charge (created for API docs)",
          refunded: false,
          fraud_details: %{},
          on_behalf_of: build(:account),
          paid: true,
          created: ~N[2018-05-28 18:32:45],
          amount_refunded: 0,
          captured: false,
          source_transfer: build(:transfer),
          transfer: build(:transfer),
          amount: 100,
          object: "charge",
          status: "succeeded"
        }
      end

      def transfer_factory do
        %Transfer{
          id: sequence(:id, &"test_transfer#{&1}"),
          amount: 1100,
          amount_reversed: 0,
          balance_transaction: build(:balance_transaction),
          created: ~N[2018-05-28 18:32:53],
          currency: build(:currency),
          destination: build(:account),
          destination_payment: "py_Cwjc8bexq2WYfz",
          metadata: %{},
          object: "transfer",
          reversed: false,
          source_type: "card",
          transfer_group: nil
        }
      end

      def transfer_reversal_factory do
        %TransferReversal{
          id: sequence(:id, &"test_transfer_reversal#{&1}"),
          amount: 1100,
          balance_transaction: build(:balance_transaction),
          created: ~N[2018-05-28 18:32:53],
          currency: build(:currency),
          metadata: %{},
          object: "transfer_reversal",
          transfer: build(:transfer)
        }
      end

      def refund_factory do
        %Refund{
          id: sequence(:id, &"test_refund#{&1}"),
          balance_transaction: build(:balance_transaction),
          charge: build(:charge),
          currency: build(:currency),
          amount: 100,
          created: ~N[2018-05-28 18:32:46],
          metadata: %{},
          object: "refund",
          status: "succeeded"
        }
      end

      def payout_factory do
        %Payout{
          id: sequence(:id, &"test_payout#{&1}"),
          amount: 1100,
          arrival_date: ~N[2018-05-28 18:32:46],
          automatic: true,
          balance_transaction: build(:balance_transaction),
          created: ~N[2018-05-28 18:32:46],
          currency: build(:currency),
          description: "STRIPE TRANSFER",
          metadata: %{},
          method: "standard",
          object: "payout",
          source_type: "card",
          status: "in_transit",
          type: "bank_account"
        }
      end

      def bank_account_factory do
        %BankAccount{
          id: sequence(:id, &"test_bank_account#{&1}"),
          account: build(:account),
          account_holder_name: "Jane Austen",
          account_holder_type: "individual",
          bank_name: "STRIPE TEST BANK",
          country: build(:country),
          currency: build(:currency),
          customer: build(:customer),
          default_for_currency: false,
          fingerprint: "vZDTTGwnLhYpF78J",
          last4: "6789",
          metadata: %{},
          object: "bank_account",
          routing_number: "110000000",
          status: "new"
        }
      end

      def card_factory do
        %Card{
          id: sequence(:id, &"test_card#{&1}"),
          brand: "Visa",
          country: build(:country),
          customer: build(:customer),
          exp_month: 8,
          exp_year: 2019,
          fingerprint: "m9nJOqUqP8boDe0c",
          funding: "credit",
          last4: "4242",
          metadata: %{},
          object: "card"
        }
      end

      def source_factory do
        %Source{
          id: sequence(:id, &"test_source#{&1}"),
          client_secret: "src_client_secret_CwjcOVbJVSfjA0oMnSUbzhk7",
          created: ~N[2018-05-28 18:32:48],
          currency: build(:currency),
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
          status: "pending",
          type: "ach_credit_transfer",
          usage: "reusable",
          customer: build(:customer)
        }
      end
    end
  end
end
