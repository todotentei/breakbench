defmodule Breakbench.AddressComponents.AdministrativeAreaLevel2 do
  use Ecto.Schema
  import Ecto.Changeset


  schema "administrative_area_level_2s" do
    field :long_name, :string
    field :short_name, :string

    belongs_to :country, Breakbench.AddressComponents.Country,
      foreign_key: :country_short_name, references: :short_name, type: :string

    timestamps()
  end

  @doc false
  def changeset(administrative_area_level2, attrs) do
    administrative_area_level2
    |> cast(attrs, [:country_short_name, :short_name, :long_name])
    |> validate_required([:country_short_name, :short_name, :long_name])
    |> unique_constraint(:country_short_name, name: :administrative_area_level_2s_country_short_name_long_name_index)
  end
end
