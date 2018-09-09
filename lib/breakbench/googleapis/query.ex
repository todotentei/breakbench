defmodule Breakbench.GoogleAPIs.Query do
  @moduledoc false

  def encode(data) do
    data
    |> resolve()
    |> URI.encode_query()
  end


  ## Private

  defp resolve(data) do
    Enum.map data, fn
      {k, v} when is_list(v) -> {k, Enum.join(v, "|")}
      {k, v} -> {k, v}
    end
  end
end
