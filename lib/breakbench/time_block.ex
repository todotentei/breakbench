defmodule Breakbench.TimeBlock do
  use Application

  import Supervisor.Spec

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Don't start charge
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def start_link do
    children = [
      worker(Breakbench.TimeBlock.ArrangeState, [])
    ]

    Supervisor.start_link(children, [
          name: __MODULE__,
      strategy: :one_for_one
    ])
  end


  ## Callbacks

  alias Breakbench.TimeBlock.Arrange


  def build(attrs \\ %{}) do
    Map.new([
      day_of_week: attrs.day_of_week,
      start_time: attrs.start_time,
      end_time: attrs.end_time,
      from_date: attrs.from_date,
      through_date: attrs.through_date
    ])
  end

  defdelegate merge(time_blocks, new_time_block), to: Arrange
  defdelegate split(time_blocks, new_time_block), to: Arrange
end
