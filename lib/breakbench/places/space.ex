defmodule Breakbench.Places.Space do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :string, []}
  schema "spaces" do
    field :phone, :string
    field :email, :string
    field :website, :string
    field :about, :string
    field :address, :string
    field :latitude, :float
    field :longitude, :float
    field :timezone, :string

    belongs_to :locality, Breakbench.AddressComponents.Locality, on_replace: :nilify
    belongs_to :currency, Breakbench.Exchanges.Currency, type: :string,
      foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :owner, Breakbench.Accounts.User, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(space, attrs) do
    space
    |> cast(attrs, [:id, :owner_id, :currency_code, :phone, :email, :website,
       :about, :address, :latitude, :longitude, :timezone, :locality_id])
    |> validate_required([:id])
  end
end
