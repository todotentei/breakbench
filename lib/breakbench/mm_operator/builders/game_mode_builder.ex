defmodule Breakbench.MMOperator.Builders.GameModeBuilder do
  @moduledoc false

  alias Breakbench.Matchmaking.MatchmakingQueue, as: Queue
  alias Breakbench.Activities.GameMode


  def build(%Queue{} = queue, game_modes) when is_list(game_modes) do
    Enum.map(game_modes, & build(queue, &1))
  end

  def build(%Queue{} = queue, %GameMode{} = game_mode) do
    %{
      matchmaking_queue_id: queue.id,
      game_mode_id: game_mode.id
    }
  end
end
