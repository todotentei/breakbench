defmodule Breakbench.StripePaymentMethods.Source do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :string, []}
  schema "sources" do
    field :object, :string
    field :amount, :integer
    field :client_secret, :string
    field :code_verification, :map
    field :created, :utc_datetime
    field :flow, :string
    field :metadata, :map
    field :owner, :map
    field :receiver, :map
    field :redirect, :map
    field :statement_descriptor, :string
    field :status, :string
    field :type, :string
    field :usage, :string

    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :customer, Breakbench.StripeResources.Customer, type: :string,
      on_replace: :nilify
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:id, :object, :amount, :client_secret, :code_verification, :created,
         :currency_code, :flow, :metadata, :owner, :receiver, :redirect, :statement_descriptor,
         :status, :type, :usage, :customer_id])
    |> validate_inclusion(:object, ["source"])
    |> validate_required([:id])
  end
end
