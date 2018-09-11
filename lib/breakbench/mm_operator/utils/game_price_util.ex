defmodule Breakbench.MMOperator.Utils.GamePriceUtil do
  @moduledoc false

  import Ecto.Query
  import Breakbench.PostgrexFuncs

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
    query = tp_query(game_area.id, kickoff, duration)
    Repo.one(query)
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


  ## Private

  defp tp_query(game_area_id, kickoff, duration) do
    from gaa in GameArea,
      where: gaa.id == ^game_area_id,
      select: fn_total_game_price(gaa.id, ^kickoff, ^duration)
  end
end
