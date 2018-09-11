defmodule Breakbench.MMOperator.Utils.QueueUtil do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

  alias Breakbench.Repo

  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode
  alias Breakbench.Matchmaking.MatchmakingQueue


  def queuers(%Space{} = space, %GameMode{} = game_mode) do
    query = queuers_query(space.id, game_mode.id, game_mode.number_of_players)
    Repo.all(query)
  end


  ## Private

  defp queuers_query(space_id, game_mode_id, number_of_players) do
    from mmq in MatchmakingQueue,
      inner_join: que in fragment("
        SELECT matchmaking_queue_id FROM ?
      ", fn_queuers(^space_id, ^game_mode_id)),
        on: mmq.id == que.matchmaking_queue_id,
      where: mmq.status == "queued",
      limit: ^number_of_players,
      lock: "FOR UPDATE"
  end
end
