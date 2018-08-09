defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.FacilitiesFactory
  use Breakbench.RegionsFactory

  use Breakbench.Accounts.BookingFactory
  use Breakbench.CurrencyFactory
  use Breakbench.GameModeFactory
  use Breakbench.MatchFactory
  use Breakbench.MatchmakingFactory
  use Breakbench.SportFactory
  use Breakbench.TimeBlockFactory
  use Breakbench.UserFactory
end
