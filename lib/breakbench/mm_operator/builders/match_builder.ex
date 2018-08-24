defmodule Breakbench.MMOperator.Builders.MatchBuilder do
  @moduledoc false

  alias Breakbench.StripeES
  alias Breakbench.Activities.GameMode


  def build(%GameMode{} = game_mode) do
    %{
      game_mode_id: game_mode.id,
      stripe_transfer_group: StripeES.match()
    }
  end
end
