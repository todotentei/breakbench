defmodule Breakbench.StripeES do
  use EntropyString, total: 1.0e12, risk: 1.0e12

  @doc """
  Generate unique match for stripe transfer group.
  """
  def match do
    "match_" <> __MODULE__.random()
  end
end
