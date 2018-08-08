defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.AreaFactory
  use Breakbench.CountryFactory
  use Breakbench.CurrencyFactory
  use Breakbench.StripeFactory
  use Breakbench.SportFactory
  use Breakbench.UserFactory
  use Breakbench.SpaceFactory
  use Breakbench.TimeBlockFactory
  use Breakbench.FieldFactory
  use Breakbench.Accounts.BookingFactory
  use Breakbench.MatchmakingFactory
  use Breakbench.GameModeFactory
end
