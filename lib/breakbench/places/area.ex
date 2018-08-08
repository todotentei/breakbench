defmodule Breakbench.Places.Area do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "areas" do
    belongs_to :space, Breakbench.Places.Space,
      type: :string
  end

  @doc false
  def changeset(area, attrs) do
    area
    |> cast(attrs, [:space_id])
    |> validate_required([:space_id])
  end
end
