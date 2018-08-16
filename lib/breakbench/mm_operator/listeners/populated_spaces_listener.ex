defmodule Breakbench.MMOperator.PopulatedSpacesListener do
  use GenServer

  alias Breakbench.MMOperator.MatchProcess


  @channel "populated_spaces"
  def channel, do: @channel

  def start_link() do
    GenServer.start_link(__MODULE__, [], [ name: __MODULE__ ])
  end


  ## Callbacks

  def init(_) do
    {:ok, pid} = :breakbench
    |> Application.get_env(Breakbench.Repo)
    |> Postgrex.Notifications.start_link()

    {:ok, ref} = Postgrex.Notifications.listen(pid, @channel)
    {:ok, {pid, @channel, ref}}
  end

  def terminate(_reason, _state), do: :ok

  def handle_info({:notification, _pid, _ref, @channel, payload}, state) do
    populated_spaces = payload
    |> Poison.decode!
    |> AtomicMap.convert(safe: false)

    try do
      Enum.each populated_spaces, & MatchProcess.run/1

      Enum.each populated_spaces, fn ps ->
        case MatchProcess.run(ps) do
          {:ok, _} -> throw :match
          {:error, _} -> :error
        end
      end
    catch
      :match -> :ok
    end

    {:noreply, state}
  end
end
