defmodule Breakbench.Matchmaking.MatchmakingSpaceDistanceMatrix do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key false
  schema "matchmaking_space_distance_matrices" do
    field :distance, :integer
    field :duration, :integer


    belongs_to :space, Breakbench.Regions.Space,
      type: :string
    belongs_to :matchmaking_queue, Breakbench.Matchmaking.MatchmakingQueue,
      type: :binary_id
  end

  @doc false
  def changeset(distance_matrix, attrs) do
    distance_matrix
      |> cast(attrs, [:distance, :duration, :space_id, :matchmaking_queue_id])
      |> validate_required([:distance, :duration, :space_id, :matchmaking_queue_id])
  end
end
