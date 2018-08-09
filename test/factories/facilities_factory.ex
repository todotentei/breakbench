defmodule Breakbench.FacilitiesFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Facilities.AreaFactory
      use Breakbench.Facilities.FieldFactory
      use Breakbench.Facilities.SpaceFactory
    end
  end
end
