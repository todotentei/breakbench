defmodule Breakbench.Auth.Plugs do
  @moduledoc false

  alias Breakbench.Auth.Plugs.{
    EnsureAuthenticated,
    EnsureOwnership,
    EnsureUnauthenticated
  }


  @doc """
  Plug to only allow authenticated users to access the resource.
  """
  defdelegate ensure_authenticated(conn, opts),
    to: EnsureAuthenticated, as: :check

  @doc """
  Plug to only allow authenticated users with the correct id to access the resource.
  """
  defdelegate ensure_ownership(conn, opts),
    to: EnsureOwnership, as: :check

  @doc """
  Plug to only allow unauthenticated users to access the resource.
  """
  defdelegate ensure_unauthenticated(conn, opts),
    to: EnsureUnauthenticated, as: :check
end
