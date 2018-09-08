defmodule Breakbench.Regions do
  @moduledoc "The Regions context"

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Regions.Country

  @doc """
  Generates a changeset for the region schemas.
  """
  @spec changeset(term :: atom) :: Ecto.Changeset.t
  def changeset(:country) do
    Country.changeset(%Country{}, %{})
  end

  @doc """
  Creates a country.
  """
  @spec create_country(
    attrs :: map
  ) :: {:ok, Country.t}
     | {:error, Ecto.Changeset.t}
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end
end
