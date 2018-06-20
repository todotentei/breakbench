defmodule Breakbench.CurrencyTest do
  use Breakbench.DataCase
  import Breakbench.Factory

  alias Breakbench.Exchanges

  describe "currencies" do
    alias Breakbench.Exchanges.Currency

    @update_attrs %{name: "updated_name"}

    test "list_currencies/0 returns all currencies" do
      [currency_one, currency_two] = insert_pair(:currency)
      assert Exchanges.list_currencies() == [currency_one, currency_two]
    end

    test "get_currency!/1 returns the currency with given code" do
      currency = insert(:currency)
      assert Exchanges.get_currency!(currency.code) == currency
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = insert(:currency)
      assert {:ok, currency} = Exchanges.update_currency(currency, @update_attrs)
      assert %Currency{} = currency
      assert currency.name == @update_attrs.name
    end

    test "delete_currency/1 deletes the currency" do
      currency = insert(:currency)
      assert {:ok, %Currency{}} = Exchanges.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Exchanges.get_currency!(currency.code) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = insert(:currency)
      assert %Ecto.Changeset{} = Exchanges.change_currency(currency)
    end
  end
end
