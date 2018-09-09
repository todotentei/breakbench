defmodule Breakbench.MMOperator.Cores.MatchCore do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.Accounts

  alias Breakbench.Accounts.{
    Match, MatchMember
  }
  alias Breakbench.Facilities.Space
  alias Breakbench.Activities.GameMode

  alias Breakbench.MMOperator.QueueStats
  alias Breakbench.MMOperator.Builders.{
    DelayBuilder, MatchBuilder, MatchMemberBuilder
  }
  alias Breakbench.MMOperator.Utils.{
    GamePriceUtil, PlayTimeUtil, QueueUtil
  }

  import Breakbench.PostgrexHelper, only: [to_secs_interval: 1]


  @spec run(
    space :: Space.t(),
    game_mode :: GameMode.t()
  ) :: {:ok, Match.t()} | {:error, atom()}
  def run(%Space{} = space, %GameMode{} = game_mode) do
    Repo.transaction fn ->
      # Use space currency as the default currency
      currency_code = space.currency_code

      # Get all queuers from a specific game mode of a space (preload user)
      queuers = list_queuers(space, game_mode)
      users = Enum.map(queuers, & Map.get(&1, :user))

      # Game play period
      duration = to_secs_interval(game_mode.duration)

      # Longest duration required by queuer to travel from origin to destination
      # Added by extra delay time of 15 minutes (900 seconds)
      last_queuer = List.last(queuers)
      delay = DelayBuilder.build(last_queuer, space, 900)

      # Search for next available play time at specific space & game mode
      searchrange =
        space.timezone
        |> Timex.now()
        |> Timex.to_erl()
        |> NaiveDateTime.from_erl!()
        |> PlayTimeUtil.searchrange(duration, delay)

      # Search for next available play time
      %{game_area: game_area, available: available} =
        next_available(space, game_mode, searchrange)

      # Use the earliest available time as kickoff
      # And game mode duration as game play
      kickoff = hd(available)
      game_play = game_mode.duration

      # Calc total game price of a specific game area between kickoff time
      # and the end of game play
      total_price = get_price(game_area, kickoff, game_play)

      with {:ok, %Match{} = match} <- new_match_with_game_mode(game_mode),
           {:ok, _} <- QueueStats.set(:matched, queuers)
      do
        # Put all related queuers to match members
        members_attrs = MatchMemberBuilder.build(match, users)
        Repo.insert_all(MatchMember, members_attrs)

        case Accounts.create_booking(%{
          kickoff: kickoff,
          price: total_price,
          currency_code: currency_code,
          duration: game_play,
          game_mode_id: game_mode.id,
          game_area_id: game_area.id,
          match_id: match.id
        }) do
          {:ok, _} -> match
          {:error, _} -> Repo.rollback(:booking_error)
        end
      else
        {:error, error_type} when error_type in [
          :queue_status_error, :stale_queue_error
        ] ->
          Repo.rollback(error_type)
        {:error, _} ->
          Repo.rollback(:new_match_error)
      end
    end
  end


  ## Private

  defp list_queuers(space, game_mode) do
    nop = game_mode.number_of_players

    case space_queuers__preload_user(space, game_mode) do
      queuers when length(queuers) == nop ->
        queuers
      _ ->
        Repo.rollback(:number_of_players_invalid)
    end
  end

  defp get_price(game_area, kickoff, duration) do
    case GamePriceUtil.total(game_area, kickoff, duration) do
      price when price >= 0 ->
        price
      _ ->
        Repo.rollback(:game_price_invalid)
    end
  end

  defp next_available(space, game_mode, searchrange) do
    case PlayTimeUtil.next_available(space, game_mode, searchrange) do
      [%{game_area: _, available: _} = next_available | _] ->
        next_available
      [] ->
        Repo.rollback(:next_available_invalid)
    end
  end

  defp new_match_with_game_mode(game_mode) do
    game_mode
    |> MatchBuilder.build()
    |> Accounts.create_match()
  end

  defp space_queuers__preload_user(space, game_mode) do
    space
    |> QueueUtil.queuers(game_mode)
    |> Repo.preload(:user)
  end
end
