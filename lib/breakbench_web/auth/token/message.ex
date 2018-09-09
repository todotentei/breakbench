defmodule BreakbenchWeb.Auth.Message do
  @derive Jason.Encoder

  @enforce_keys [:data, :exp]
  defstruct [:data, :exp]

  def encode(value, opts) do
    value
    |> Map.take([:data, :exp])
    |> Jason.Encode.map(opts)
  end

  def to_struct(%{"data" => data, "exp" => exp}) do
    struct(__MODULE__, [{:data, data}, {:exp, exp}])
  end
end
