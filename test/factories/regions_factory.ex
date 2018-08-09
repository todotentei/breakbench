defmodule Breakbench.RegionsFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Regions.CountryFactory
    end
  end
end
