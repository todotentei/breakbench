defmodule Breakbench.MatchmakingJob.MatchTrigger do
  @moduledoc false

  alias Breakbench.Matchmaking.MatchmakingQueue
  alias Breakbench.Repo


  def perform(%MatchmakingQueue{} = queue) do
    "SELECT match_lookup($1, $2)"
      |> Repo.query!([queue.geom, queue.radius])
  end
end
