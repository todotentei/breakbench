defmodule Breakbench.AddressComponents.ColloquialAreaLocalities do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "colloquial_area_localities" do
    belongs_to :colloquial_area, Breakbench.AddressComponents.ColloquialArea
    belongs_to :locality, Breakbench.AddressComponents.Locality
  end

  @doc false
  def changeset(colloquial_localities, attrs) do
    colloquial_localities
    |> cast(attrs, [:colloquial_area_id, :locality_id])
    |> foreign_key_constraint(:colloquial_area_id)
    |> foreign_key_constraint(:locality_id)
    |> unique_constraint(:locality_id)
  end
end
