defmodule Breakbench.MMOperator.Utils.QueueUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode
  alias Breakbench.Matchmaking.MatchmakingQueue


  def queuers(%Space{} = space, %GameMode{} = game_mode) do
    from(MatchmakingQueue)
    |> join(:inner, [mmq], que in fragment("SELECT matchmaking_queue_id AS id FROM queuers(?,?)",
        ^space.id, type(^game_mode.id, :binary_id)), mmq.id == que.id)
    |> where([mmq], mmq.status == "queued")
    |> limit(^game_mode.number_of_players)
    |> lock("FOR UPDATE")
    |> Repo.all
  end
end
