defmodule Breakbench.MatchmakingJob.MatchListener do
  use GenServer

  @channel "match"


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
    decoded = payload
      |> Poison.decode!
      |> AtomicMap.convert(safe: false)

    IO.inspect(decoded)

    {:noreply, state}
  end
end
