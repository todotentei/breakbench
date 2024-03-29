defmodule Breakbench.MMOperator do
  @moduledoc "Matchmaking Operator"

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
      worker(Breakbench.MMOperator.MatchUp, []),
      worker(Breakbench.MMOperator.Payment, [])
    ]

    Supervisor.start_link(children, [
          name: __MODULE__,
      strategy: :one_for_one
    ])
  end
end
