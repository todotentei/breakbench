defmodule Breakbench.AddressComponents.AdministrativeAreaLevel2PostalCodes do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_2_postal_codes" do
    belongs_to :administrative_area_level_2, Breakbench.AddressComponents.AdministrativeAreaLevel2
    belongs_to :postal_code, Breakbench.AddressComponents.PostalCode
  end

  @doc false
  def changeset(administrative_area_level2_postal_codes, attrs) do
    administrative_area_level2_postal_codes
    |> cast(attrs, [:administrative_area_level_2_id, :postal_code_id])
    |> foreign_key_constraint(:administrative_area_level_2_id,
         name: :area_level_2_postal_codes_area_level_2_id)
    |> foreign_key_constraint(:postal_code_id,
         name: :area_level_2_postal_codes_postal_code_id)
    |> unique_constraint(:postal_code_id,
         name: :area_level_2_postal_codes_postal_code_id)
  end
end
