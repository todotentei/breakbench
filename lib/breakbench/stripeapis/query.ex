defmodule Breakbench.StripeAPIs.Query do
  @moduledoc """
  Curl query
  """

  @doc """
  Encode the given map or list of tuples.
  Origin: https://github.com/elixir-lang/plug/blob/master/lib/plug/conn/query.ex
  """
  def encode(data) do
    resolved = resolve("", data)
    # Encode resolved data
    URI.encode_query(resolved)
  end


  ## Private

  # Struct
  defp resolve(key, %{__struct__: struct = data}) when is_atom(struct) do
    [{key, to_string(data)}]
  end

  # Map
  defp resolve(key, data) when is_map(data) do
    flatten(data, key)
  end

  # Keyword
  defp resolve(key, data) when is_list(data) and is_tuple(hd data) do
    data
      |> Enum.uniq_by(&elem(&1, 0))
      |> flatten(key)
  end

  # Non-keyword
  defp resolve(key, data) when is_list(data) do
    Enum.flat_map(data, & resolve("#{key}[]", &1))
  end

  # Fallback
  defp resolve(key, value) do
    [{key, to_string(value)}]
  end

  defp flatten(data, key) do
    Enum.flat_map data, fn
      {_, v} when v in [%{}, []] ->
        []
      {k, v} ->
        k = if key == "", do: to_string(k), else: "#{key}[#{to_string(k)}]"
        resolve(k, v)
    end
  end
end
