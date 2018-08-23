defmodule Breakbench.ChargeCoreTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.MMOperator.ChargeCore

  alias Breakbench.Accounts.MatchMember
  alias Breakbench.Balances.OutstandingBalance


  describe "mm_operator charge core" do
    setup do
      currency = insert(:currency)

      {:ok, currency: currency}
    end

    test "run/1 with valid attrs returns a match member", %{currency: currency} do
      user = insert(:user, stripe_customer: "ok_customer")
      member = insert(:match_member, user: user)

      assert {:ok, %MatchMember{} = member} = ChargeCore.run(member, currency, 2000)
      assert member.stripe_charge == "test_customer"
    end

    test "run/1 with bad customer returns an outstanding balance", %{currency: currency} do
      user = insert(:user, stripe_customer: "error_customer")
      member = insert(:match_member, user: user)

      assert {:ok, %OutstandingBalance{}} = ChargeCore.run(member, currency, 2000)
    end
  end
end
