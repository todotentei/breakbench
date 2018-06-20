defmodule Breakbench.MockServer do
  @moduledoc false
  defmacro __using__ _ do
    quote do
      import Breakbench.MockServer

      @callback request(method :: atom, path :: binary, data :: map) :: tuple

      def request(method, path, data) do
        IO.inspect("Mock Server: #{to_string(method)} #{path} #{inspect(data)}")
        {:ok, %{status_code: 200, body: "{}"}}
      end

      defoverridable [request: 3]
    end
  end

  defmacro record(name, data) do
    quote do
      def unquote(name)(changes \\ []) do
        mesh = fn {k, v}, acc -> Map.put(acc, k, v) end
        changes
          |> Enum.reduce(Map.new(unquote(data)), mesh)
          |> Map.new()
      end
    end
  end
end
