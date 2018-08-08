defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.AreaFactory
  use Breakbench.Accounts.BookingFactory
  use Breakbench.CountryFactory
  use Breakbench.CurrencyFactory
  use Breakbench.FieldFactory
  use Breakbench.GameModeFactory
  use Breakbench.MatchFactory
  use Breakbench.MatchmakingFactory
  use Breakbench.SpaceFactory
  use Breakbench.SportFactory
  use Breakbench.StripeFactory
  use Breakbench.TimeBlockFactory
  use Breakbench.UserFactory
end
