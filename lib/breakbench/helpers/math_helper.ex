defmodule Breakbench.MathHelper do
  @moduledoc "Math helper"


  @doc """
  Ceil `number` to the nearest multiple of `base`

  ## Examples

      iex> ceil_to_the_nearest_multiple(1, 1.5)
      1.5

      iex> ceil_to_the_nearest_multiple(453.1, 500)
      500.0

  """
  def ceil_to_the_nearest_multiple(number, base) do
    :math.ceil(number / base) * base
  end
end
