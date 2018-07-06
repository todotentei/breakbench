defmodule Breakbench.Places.GroundClosingHour do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "ground_closing_hours" do
    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: :true, type: :binary_id
    belongs_to :ground, Breakbench.Places.Ground,
      type: :string
  end


  @doc false
  def changeset(ground_closing_hour, attrs) do
    ground_closing_hour
      |> cast(attrs, [:time_block_id, :ground_id])
      |> validate_required([:time_block_id, :ground_id])
  end
end
