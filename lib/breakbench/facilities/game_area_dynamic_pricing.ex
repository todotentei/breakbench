defmodule Breakbench.Facilities.GameAreaDynamicPricing do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "game_area_dynamic_pricings" do
    field :price, :integer

    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: :true, type: :binary_id
    belongs_to :game_area, Breakbench.Facilities.GameArea,
      type: :binary_id
  end

  @doc false
  def changeset(game_area_dynamic_pricing, attrs) do
    game_area_dynamic_pricing
    |> cast(attrs, [:price, :time_block_id, :game_area_id])
    |> validate_required([:price, :time_block_id, :game_area_id])
  end
end
