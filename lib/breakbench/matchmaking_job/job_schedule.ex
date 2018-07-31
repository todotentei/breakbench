defmodule Breakbench.MatchmakingJob.JobSchedule do
  @moduledoc false

  alias Breakbench.Matchmaking


  def perform(mmq_id) do
    Matchmaking.get_queue!(mmq_id)
  end
end
