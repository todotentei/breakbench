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


alias Breakbench.{Repo, Sport}
alias Breakbench.AddressComponents.Country

# Json file reader's helper
read! = & __DIR__
  |> Path.join(&1)
  |> File.read!
  |> Poison.decode!

for {short_name, long_name} <- read!.("seeds/countries.json") do
  attrs = %{short_name: short_name, long_name: long_name}
  Repo.get(Country, short_name) || AddressComponents.create_country(attrs)
end

for {type, sports} <- read!.("seeds/sports.json"), sport <- sports do
  attrs = %{name: sport, type: type}
  Repo.get(Sport, sport) || Repo.insert!(struct(Sport, attrs))
end
