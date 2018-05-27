defmodule Breakbench.AddressComponents.ColloquialAreaPostalCodes do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "colloquial_area_postal_codes" do
    belongs_to :colloquial_area, Breakbench.AddressComponents.ColloquialArea
    belongs_to :postal_code, Breakbench.AddressComponents.PostalCode
  end

  @doc false
  def changeset(colloquial_postal_codes, attrs) do
    colloquial_postal_codes
    |> cast(attrs, [:colloquial_area_id, :postal_code_id])
    |> foreign_key_constraint(:colloquial_area_id)
    |> foreign_key_constraint(:postal_code_id)
    |> unique_constraint(:postal_code_id)
  end
end
