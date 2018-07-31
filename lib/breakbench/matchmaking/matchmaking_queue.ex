defmodule Breakbench.Matchmaking.MatchmakingQueue do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "matchmaking_queues" do
    field :geom, Geo.PostGIS.Geometry
    field :radius, :integer, default: 0
    field :status, :string, default: "queued"
    field :lock_version, :integer, default: 1


    belongs_to :rule, Breakbench.Matchmaking.MatchmakingRule,
      type: :binary_id


    has_many :game_modes, Breakbench.Matchmaking.MatchmakingGameMode,
      foreign_key: :matchmaking_queue_id


    timestamps()
  end

  @doc false
  def changeset(queue, attrs) do
    queue
      |> cast(attrs, [:geom, :rule_id, :radius, :status])
      |> optimistic_lock(:lock_version)
      |> validate_required([:geom, :rule_id, :radius])
  end
end
