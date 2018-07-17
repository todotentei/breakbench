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
    field :geom, Geo.PostGIS.Geometry
    field :timezone, :string


    belongs_to :currency, Breakbench.Exchanges.Currency,
      type: :string, foreign_key: :currency_code, references: :code, on_replace: :nilify
    belongs_to :owner, Breakbench.Accounts.User,
      on_replace: :nilify


    has_many :opening_hours, Breakbench.Places.SpaceOpeningHour


    timestamps()
  end

  @doc false
  def changeset(space, attrs) do
    space
    |> cast(attrs, [:id, :owner_id, :currency_code, :phone, :email, :website,
       :about, :address, :geom, :timezone])
    |> validate_required([:id])
  end
end
