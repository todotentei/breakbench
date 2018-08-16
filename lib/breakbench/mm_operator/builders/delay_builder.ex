defmodule Breakbench.MMOperator.DelayBuilder do
  @moduledoc false

  alias Breakbench.Matchmaking.MatchmakingQueue, as: Queue
  alias Breakbench.Facilities.Space

  alias Breakbench.MMOperator.DistanceMatrixUtil

  import Breakbench.PostgrexHelper, only: [to_secs_interval: 1]


  def build(%Queue{} = queue, %Space{} = space, extra_delay \\ 900) do
    queue
    |> DistanceMatrixUtil.get_duration(space)
    |> Kernel.+(extra_delay)
    |> to_secs_interval
  end
end
