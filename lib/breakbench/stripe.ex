defmodule Breakbench.Stripe do
  use Application

  import Supervisor.Spec

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Don't start charge
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def start_link do
    children = [
      worker(Breakbench.Account.BankAccountStripe, []),
      worker(Breakbench.Account.CardStripe, []),
      worker(Breakbench.AccountStripe, []),
      worker(Breakbench.BalanceTransactionStripe, []),
      worker(Breakbench.ChargeStripe, []),
      worker(Breakbench.Customer.BankAccountStripe, []),
      worker(Breakbench.Customer.CardStripe, []),
      worker(Breakbench.Customer.SourceStripe, []),
      worker(Breakbench.CustomerStripe, []),
      worker(Breakbench.PayoutStripe, []),
      worker(Breakbench.RefundStripe, []),
      worker(Breakbench.SourceStripe, []),
      worker(Breakbench.TransferReversalStripe, []),
      worker(Breakbench.TransferStripe, [])
    ]

    Supervisor.start_link(children, [
          name: __MODULE__,
      strategy: :one_for_one
    ])
  end
end
