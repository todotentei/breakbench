defmodule Breakbench.Facilities.Field do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :string, []}
  schema "fields" do
    field :name, :string

    belongs_to :area, Breakbench.Facilities.Area,
      type: :binary_id

    has_many :closing_hours, Breakbench.Facilities.FieldClosingHour

    timestamps()
  end

  @doc false
  def changeset(field, attrs) do
    field
    |> cast(attrs, [:id, :name, :area_id])
    |> validate_required([:id, :area_id])
  end
end
