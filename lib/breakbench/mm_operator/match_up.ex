defmodule Breakbench.MMOperator.MatchUp do
  @moduledoc false
  use GenServer

  alias Breakbench.Accounts.Match

  alias Breakbench.MMOperator.Payment
  alias Breakbench.MMOperator.Utils.MatchUpUtil
  alias Breakbench.MMOperator.Cores.MatchCore


  @doc false
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  @doc """
  Trigger match lookup
  """
  def trigger(%Geo.Point{} = geom, radius) do
    GenServer.cast(__MODULE__, {:trigger, geom, radius})
  end


  ## Callbacks

  def init(_arg), do: {:ok, []}
  def terminate(_reason, _state), do: :ok

  def handle_cast({:trigger, geometry, radius}, state) do
    try do
      geometry
      |> MatchUpUtil.populated_spaces(radius)
      |> Enum.each(fn %{space: space, game_mode: game_mode} ->
        with {:ok, match} <- MatchCore.run(space, game_mode) do
          throw match
        end
      end)
    catch
      %Match{} = match -> Payment.charge(match)
    end

    {:noreply, state}
  end
end
