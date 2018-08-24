defmodule Breakbench.TransferCoreTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.MMOperator.Cores.TransferCore


  describe "mm_operator transfer core" do
    alias Breakbench.Accounts.Booking

    setup do
      match = insert(:match)

      {:ok, match: match}
    end

    test "run/1 a match without booking returns error", %{match: match} do
      assert {:error, :argument_error} = TransferCore.run(match)
    end

    test "run/1 with valid attrs returns an updated booking", %{match: match} do
      insert(:booking, user: nil, match: match)

      assert {:ok, %Booking{} = booking} = TransferCore.run(match)
      assert booking.stripe_transfer == "ok_transfer"
    end
  end
end
