defmodule Breakbench.MMOperator.QueueStats do
  @moduledoc false

  import Ecto.Changeset, only: [change: 2]
  alias Breakbench.Repo
  alias Breakbench.Matchmaking.MatchmakingQueue, as: Queue


  @doc """
  Set queue status to `matched`
  """
  def set(:matched, queuers) when is_list(queuers) do
    Enum.each(queuers, & set(:matched, &1))
    {:ok, length(queuers)}
  end

  def set(:matched, %Queue{} = queue) do
    try do
      case set_status(queue, "matched") do
        {:ok, _} = updated -> updated
        {:error, _} -> Repo.rollback(:queue_status_error)
      end
    rescue
      Ecto.StaleModelError -> Repo.rollback(:stale_queue_error)
    end
  end


  ## Private

  defp set_status(data, status) do
    data
    |> change(status: status)
    |> Repo.update
  end
end
