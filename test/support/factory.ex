defmodule Breakbench.Factory do
  use ExMachina.Ecto, repo: Breakbench.Repo

  use Breakbench.AccountsFactory
  use Breakbench.ActivitiesFactory
  use Breakbench.BalancesFactory
  use Breakbench.ExchangesFactory
  use Breakbench.FacilitiesFactory
  use Breakbench.MatchmakingFactory
  use Breakbench.RegionsFactory
  use Breakbench.TimesheetsFactory
end
