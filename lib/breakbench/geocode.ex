defmodule Breakbench.Geocode do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Don't start host
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def start_link(_opts \\ []) do
    import Supervisor.Spec

    children = [
      # Start google geocode depot
      worker(Breakbench.Geocode.Google, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
