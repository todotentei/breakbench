defmodule Breakbench.Regions do
  @moduledoc "The Regions context"

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Regions.Country

  @doc """
  Generates a changeset for the region schemas.
  """
  @spec changeset(term :: atom(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(atom, attrs \\ %{})
  def changeset(:country, attrs) do
    Country.changeset(%Country{}, attrs)
  end

  @doc """
  Creates a country.
  """
  @spec create_country(
    attrs :: map()
  ) :: {:ok, Country.t()} | {:error, Ecto.Changeset.t()}
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end
end
