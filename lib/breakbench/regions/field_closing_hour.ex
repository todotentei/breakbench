defmodule Breakbench.Regions.FieldClosingHour do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "field_closing_hours" do
    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: :true, type: :binary_id
    belongs_to :field, Breakbench.Regions.Field,
      type: :string
  end

  @doc false
  def changeset(field_closing_hour, attrs) do
    field_closing_hour
      |> cast(attrs, [:time_block_id, :field_id])
      |> validate_required([:time_block_id, :field_id])
  end
end
