defmodule Breakbench.Matchmaking.MatchmakingTravelMode do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  @foreign_key_type :string
  schema "matchmaking_travel_modes" do
    field :type, :string, primary_key: true
  end

  @doc false
  def changeset(travel_mode, attrs) do
    travel_mode
      |> cast(attrs, [:type])
      |> validate_required([:type])
  end
end
