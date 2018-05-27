defmodule Breakbench.AddressComponents.PostalCode do
  use Ecto.Schema
  import Ecto.Changeset


  schema "postal_codes" do
    field :long_name, :string
    field :short_name, :string

    belongs_to :country, Breakbench.AddressComponents.Country,
      foreign_key: :country_short_name, references: :short_name, type: :string

    timestamps()
  end

  @doc false
  def changeset(postal_code, attrs) do
    postal_code
    |> cast(attrs, [:country_short_name, :short_name, :long_name])
    |> validate_required([:country_short_name, :short_name, :long_name])
    |> unique_constraint(:country_short_name, name: :postal_codes_country_short_name_long_name_index)
  end
end
