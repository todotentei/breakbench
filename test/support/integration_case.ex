defmodule BreakbenchWeb.IntegrationCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's presentation layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Breakbench.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import BreakbenchWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Breakbench.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Breakbench.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Breakbench.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
