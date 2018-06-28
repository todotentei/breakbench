defmodule BreakbenchWeb.AddressComponentsResolver do
  alias Breakbench.AddressComponents

  def all_countries(_root, _args, _info) do
    countries = AddressComponents.list_countries()
    {:ok, countries}
  end
end
