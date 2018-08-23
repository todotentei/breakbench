defmodule Breakbench.MMOperator.GamePriceUtil do
  @moduledoc false

  import Ecto.Query
  alias Breakbench.Repo

  alias Breakbench.{
    Accounts, Activities
  }

  alias Breakbench.Facilities.GameArea
  alias Breakbench.Accounts.Match


  @doc """
  Calc total game price
  """
  def total(%GameArea{} = game_area, kickoff, duration) do
    from(GameArea)
    |> where([gaa], gaa.id == ^game_area.id)
    |> select([gaa], fragment("total_game_price(?,?,?)", gaa.id, ^kickoff, ^duration))
    |> Repo.one()
  end

  @doc """
  Calc each price a match member has to pay
  """
  def each(%Match{} = match) do
    booking = Accounts.get_booking!(match)
    game_mode = Activities.get_game_mode!(match)

    booking.price / game_mode.number_of_players
    |> :math.ceil()
    |> round()
  end
end
