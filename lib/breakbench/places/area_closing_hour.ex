defmodule Breakbench.Places.AreaClosingHour do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "area_closing_hours" do
    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: true, type: :binary_id
    belongs_to :area, Breakbench.Places.Area,
      type: :binary_id
  end

  @doc false
  def changeset(area_closing_hour, attrs) do
    area_closing_hour
    |> cast(attrs, [:time_block_id, :area_id])
    |> validate_required([:time_block_id, :area_id])
  end
end
