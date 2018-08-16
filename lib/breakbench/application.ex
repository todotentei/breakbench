defmodule Breakbench.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Add Verk.Supervisor to supervision tree
      supervisor(Verk.Supervisor, []),
      # Start the Ecto repository
      supervisor(Breakbench.Repo, []),
      # Start the TimeBlock module
      supervisor(Breakbench.TimeBlock, []),
      # Start the Matchmaking Operator module
      supervisor(Breakbench.MMOperator, []),
      # Start the endpoint when the application starts
      supervisor(BreakbenchWeb.Endpoint, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Breakbench.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BreakbenchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
