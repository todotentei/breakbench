defmodule Breakbench.Matchmaking.MatchmakingRule do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matchmaking_rules" do
    field :radius, :integer

    belongs_to :travel_mode, Breakbench.Matchmaking.MatchmakingTravelMode,
      type: :string, foreign_key: :travel_mode_type, references: :type
    belongs_to :availability_mode, Breakbench.Matchmaking.MatchmakingAvailabilityMode,
      type: :string, foreign_key: :availability_mode_type, references: :type
  end

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, [:radius, :travel_mode_type, :availability_mode_type])
    |> validate_required([:radius, :travel_mode_type, :availability_mode_type])
  end
end
