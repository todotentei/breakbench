defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.AddressComponents.CountryFactory
  use Breakbench.LocalityFactory
  use Breakbench.CurrencyFactory
  use Breakbench.StripeFactory
  use Breakbench.SportFactory
  use Breakbench.UserFactory
  use Breakbench.SpaceFactory
  use Breakbench.TimeBlockFactory
  use Breakbench.GroundFactory
  use Breakbench.FieldFactory
  use Breakbench.Accounts.BookingFactory
  use Breakbench.MatchmakingQueueFactory
  use Breakbench.GameModeFactory
end
