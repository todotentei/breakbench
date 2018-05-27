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

alias Ecto.Multi
alias Breakbench.Repo
alias Breakbench.AddressComponents.Country

# Json file reader's helper
read! = & __DIR__
  |> Path.join(&1)
  |> File.read!
  |> Poison.decode!
# Countries
countries = read!.("seeds/countries.json")
  |> Map.to_list
  |> Enum.map(fn {k, v} -> %{short_name: k, long_name: v} end)


Multi.new
|> Multi.insert_all(:countries, Country, countries)
|> Repo.transaction
