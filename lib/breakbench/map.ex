defmodule Breakbench.Map do
  @moduledoc false

  def pop_magic(map, key, fun) do
    map
      |> Map.update(key, nil, &(unless is_nil(&1), do: fun.(&1)))
      |> Map.pop(key)
  end
end
