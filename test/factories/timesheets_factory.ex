defmodule Breakbench.TimesheetsFactory do
  defmacro __using__ _ do
    quote do
      use Breakbench.Timesheets.TimeBlockFactory
    end
  end
end
