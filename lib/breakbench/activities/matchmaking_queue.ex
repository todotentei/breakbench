defmodule Breakbench.Activities.MatchmakingQueue do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "matchmaking_queues" do
    field :geom, Geo.PostGIS.Geometry
    field :kickoff_from, :naive_datetime
    field :kickoff_through, :naive_datetime
    field :travel_mode, :string
    field :mood, :string
    field :status, :string, default: "queued"


    timestamps()
  end

  @doc false
  def changeset(matchmaking_queue, attrs) do
    matchmaking_queue
      |> cast(attrs, [:geom, :kickoff_from, :kickoff_through, :travel_mode, :mood, :status])
      |> validate_required([:geom, :travel_mode, :mood])
  end
end
