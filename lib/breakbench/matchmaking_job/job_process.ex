defmodule Breakbench.MatchmakingJob.JobProcess do
  @moduledoc false

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode


  def process(%Space{} = space, %GameMode{} = game_mode) do
    # Search for queues within range
    queuers = space
      |> Breakbench.Matchmaking.list_queues(game_mode)
      |> Breakbench.Repo.preload(:rule)
  end
end
