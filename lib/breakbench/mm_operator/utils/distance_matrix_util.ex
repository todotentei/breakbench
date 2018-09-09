defmodule Breakbench.MMOperator.Utils.DistanceMatrixUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Matchmaking.{
    MatchmakingQueue, MatchmakingSpaceDistanceMatrix
  }
  alias Breakbench.Facilities.Space


  def get_duration(%MatchmakingQueue{} = queue, %Space{} = space) do
    from(MatchmakingQueue)
    |> join(:inner, [mmq], msd in MatchmakingSpaceDistanceMatrix,
      mmq.id == msd.matchmaking_queue_id)
    |> where([mmq], mmq.id == type(^queue.id, :binary_id))
    |> where([_, msd], msd.space_id == ^space.id)
    |> select([_, msd], msd.duration)
    |> Repo.one
  end
end
