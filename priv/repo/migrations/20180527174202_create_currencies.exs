defmodule Breakbench.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies, primary_key: false) do
      add :code, :string, primary_key: true
      add :decimal_digits, :integer
      add :name, :string
      add :name_plural, :string
      add :symbol, :string
      add :symbol_native, :string
    end

    create unique_index(:currencies, [:name])
  end
end
