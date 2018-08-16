defmodule Breakbench.MMOperator.MatchBuilder do
  @moduledoc false

  alias Breakbench.Activities.GameMode
  

  def build(%GameMode{} = game_mode) do
    %{
      game_mode_id: game_mode.id
    }
  end
end
