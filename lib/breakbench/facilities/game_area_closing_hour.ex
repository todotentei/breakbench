defmodule Breakbench.Facilities.GameAreaClosingHour do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "game_area_closing_hours" do
    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: :true, type: :binary_id
    belongs_to :game_area, Breakbench.Facilities.GameArea,
      type: :binary_id
  end

  @doc false
  def changeset(game_area_closing_hour, attrs) do
    game_area_closing_hour
      |> cast(attrs, [:time_block_id, :game_area_id])
      |> validate_required([:time_block_id, :game_area_id])
  end
end
