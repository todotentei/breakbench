defmodule Breakbench.Facilities.FieldDynamicPricing do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "field_dynamic_pricings" do
    field :price, :integer

    belongs_to :time_block, Breakbench.Timesheets.TimeBlock,
      primary_key: :true, type: :binary_id
    belongs_to :field_game_mode, Breakbench.Facilities.FieldGameMode,
      type: :binary_id
  end

  @doc false
  def changeset(field_dynamic_pricing, attrs) do
    field_dynamic_pricing
    |> cast(attrs, [:price, :time_block_id, :field_game_mode_id])
    |> validate_required([:price, :time_block_id, :field_game_mode_id])
  end
end
