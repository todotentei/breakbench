defmodule Breakbench.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false) do
      add :id, :string, primary_key: true
      add :object, :string
      add :amount, :integer
      add :client_secret, :string
      add :code_verification, :map
      add :created, :utc_datetime
      add :currency_code, references(:currencies, column: :code, type: :citext)
      add :flow, :string
      add :metadata, :map
      add :owner, :map
      add :receiver, :map
      add :redirect, :map
      add :statement_descriptor, :string
      add :status, :string
      add :type, :string
      add :usage, :string
      add :customer_id, references(:customers, type: :string)
    end

    create index(:sources, [:currency_code])
    create index(:sources, [:customer_id])
  end
end
