# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Breakbench.Repo.insert!(%Breakbench.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Breakbench.Repo
alias Breakbench.{
  Activities, Exchanges, Matchmaking, Regions
}

# Json file reader's helper
read! = & __DIR__
|> Path.join(&1)
|> File.read!
|> Poison.decode!

for {short_name, long_name} <- read!.("seeds/countries.json") do
  attrs = %{short_name: short_name, long_name: long_name}
  Repo.get(Regions.Country, short_name) ||
    Regions.create_country(attrs)
end

for {type, sports} <- read!.("seeds/sports.json"), sport <- sports do
  attrs = %{name: sport, type: type}
  Repo.get(Activities.Sport, sport) ||
    Repo.insert!(struct(Activities.Sport, attrs))
end

for currency <- read!.("seeds/currencies.json") do
  currency = AtomicMap.convert(currency, safe: false)
  Repo.get(Exchanges.Currency, currency.code) ||
    Repo.insert!(struct(Exchanges.Currency, currency))
end

for travel_mode <- ~w(Driving Transit Walking Cycling) do
  Repo.has(Matchmaking.MatchmakingTravelMode, %{type: travel_mode}) ||
    Matchmaking.create_travel_mode(%{type: travel_mode})
end
