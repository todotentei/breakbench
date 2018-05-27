defmodule Breakbench.AddressComponents.AdministrativeAreaLevel1PostalCodes do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "administrative_area_level_1_postal_codes" do
    belongs_to :administrative_area_level_1, Breakbench.AddressComponents.AdministrativeAreaLevel1
    belongs_to :postal_code, Breakbench.AddressComponents.PostalCode
  end

  @doc false
  def changeset(administrative_area_level1_postal_codes, attrs) do
    administrative_area_level1_postal_codes
    |> cast(attrs, [:administrative_area_level_1_id, :postal_code_id])
    |> foreign_key_constraint(:administrative_area_level_1_id,
         name: :area_level_1_postal_codes_area_level_1_id)
    |> foreign_key_constraint(:postal_code_id,
         name: :area_level_1_postal_codes_postal_code_id)
    |> unique_constraint(:postal_code_id,
         name: :area_level_1_postal_codes_postal_code_id)
  end
end
