defmodule Breakbench.Currency do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :code}
  @primary_key {:code, :string, []}
  schema "currencies" do
  field :decimal_digits, :integer
  field :name, :string
  field :name_plural, :string
  field :symbol, :string
  field :symbol_native, :string
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:code, :decimal_digits, :name, :name_plural,
         :symbol, :symbol_native])
    |> validate_required([:name])
  end
end
