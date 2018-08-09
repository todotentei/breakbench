defmodule Breakbench.Regions do
  @moduledoc "The Regions context"

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Regions.Country


  # Country

  def list_countries do
    Repo.all Country
  end

  def get_country!(short_name) do
    Repo.get! Country, short_name
  end

  def create_country(attrs \\ %{}) do
    %Country{}
      |> Country.changeset(attrs)
      |> Repo.insert()
  end

  def delete_country(%Country{} = country) do
    Repo.delete country
  end
end
