defmodule Breakbench.AddressComponents.PostalCodeLocalities do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "postal_code_localities" do
    belongs_to :postal_code, Breakbench.AddressComponents.PostalCode
    belongs_to :locality, Breakbench.AddressComponents.Locality
  end

  @doc false
  def changeset(postal_code_localities, attrs) do
    postal_code_localities
    |> cast(attrs, [:postal_code_id, :locality_id])
    |> foreign_key_constraint(:postal_code_id)
    |> foreign_key_constraint(:locality_id)
    |> unique_constraint(:locality_id)
  end
end
