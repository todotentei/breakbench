defmodule Breakbench.MatchmakingJob.GameModeBuilder do
  @moduledoc false

  alias Breakbench.Activities.GameMode
  alias Breakbench.Matchmaking.MatchmakingQueue


  def build(%MatchmakingQueue{} = queue, game_modes) do
    game_modes
      |> Enum.filter(&is_game_mode?/1)
      |> Enum.map(&game_mode_attrs(queue, &1))
  end


  ## Private

  defp game_mode_attrs(queue, game_mode) do
    %{
      matchmaking_queue_id: queue.id,
      game_mode_id: game_mode.id
    }
  end

  defp is_game_mode?(%GameMode{}), do: true
  defp is_game_mode?(_), do: false
end
