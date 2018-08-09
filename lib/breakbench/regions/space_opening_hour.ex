defmodule Breakbench.Regions.SpaceOpeningHour do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "space_opening_hours" do
    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: true, type: :binary_id
    belongs_to :space, Breakbench.Regions.Space,
      type: :string
  end


  @doc false
  def changeset(space_opening_hour, attrs) do
    space_opening_hour
      |> cast(attrs, [:time_block_id, :space_id])
      |> validate_required([:time_block_id, :space_id])
  end
end
