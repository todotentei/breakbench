defmodule Breakbench.Regions.AffectedField do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "affected_fields" do
    belongs_to :field, Breakbench.Regions.Field,
      type: :string, primary_key: true
    belongs_to :affected, Breakbench.Regions.Field,
      type: :string, primary_key: true
  end

  @doc false
  def changeset(affected_field, attrs) do
    affected_field
    |> cast(attrs, [:field_id, :affected_id])
    |> validate_required([:field_id, :affected_id])
    |> check_constraint(:field_id, name: :ban_self_referencing)
    |> check_constraint(:field_id, name: :directionless)
  end
end
