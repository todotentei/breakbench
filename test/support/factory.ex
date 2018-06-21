defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.AddressComponents.CountryFactory
  use Breakbench.CurrencyFactory
  use Breakbench.StripeFactory
  use Breakbench.SportFactory
  use Breakbench.UserFactory
end
