defmodule Breakbench.MMOperator.MatchManager do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.Matchmaking.MatchmakingQueue


  def matched(queuers) do
    try do
      ids = Enum.map(queuers, & &1.id)

      from(mmq in MatchmakingQueue, where: mmq.id in ^ids)
      |> Repo.update_all(set: [status: "matched"])

      {:ok, ids}
    rescue
      Ecto.StaleModelError -> Repo.rollback(:stale_queue_error)
    end
  end
end
