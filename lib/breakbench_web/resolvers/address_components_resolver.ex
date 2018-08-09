defmodule BreakbenchWeb.RegionsResolver do
  alias Breakbench.Regions

  def all_countries(_root, _args, _info) do
    countries = Regions.list_countries()
    {:ok, countries}
  end
end
