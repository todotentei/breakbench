defmodule Breakbench.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries, primary_key: false) do
      add :short_name, :string, primary_key: true
      add :long_name, :string, null: false
    end

    create unique_index(:countries, [:long_name])
  end
end
