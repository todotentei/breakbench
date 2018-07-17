defmodule BreakbenchWeb.PlacesResolver do
  alias Breakbench.Places

  def all_countries(_root, _args, _info) do
    countries = Places.list_countries()
    {:ok, countries}
  end
end
