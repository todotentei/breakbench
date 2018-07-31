defmodule Breakbench.MaxRadiusError do
  @moduledoc """
  Exceed allowance radius
  """

  defexception [
    type: :max_radius_error,
    message: "exceed maximum radius"
  ]
end
