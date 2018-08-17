defmodule Breakbench.MMOperator.MatchProcess do
  @moduledoc false

  alias Breakbench.Repo
  alias Breakbench.{
    Accounts, Activities, Facilities
  }

  alias Breakbench.Accounts.{
    Match, MatchMember
  }

  alias Breakbench.MMOperator.MatchManager
  alias Breakbench.MMOperator.{
    DelayBuilder, MatchBuilder, MatchMemberBuilder, SearchRangeBuilder
  }
  alias Breakbench.MMOperator.{
    PlayTimeUtil, QueueUtil
  }
  alias Breakbench.MMOperator.PopulatedSpaceValidator

  import Breakbench.PostgrexHelper, only: [to_secs_interval: 1]


  def run(attrs) do
    Repo.transaction fn ->
      {:ok, attrs} = PopulatedSpaceValidator.validate(attrs)

      space = Facilities.get_space!(attrs.space_id)
      game_mode = Activities.get_game_mode!(attrs.game_mode_id)

      # Get all queuers of a specific game mode from a space
      queuers = QueueUtil.queuers(space, game_mode)
      unless length(queuers) == game_mode.number_of_players do
        Repo.rollback(:invalid_number_of_players)
      end

      # Game play period
      duration = to_secs_interval(game_mode.duration)

      # Longest duration required by queuer to travel from origin to destination
      # Added by extra delay time of 15 minutes (900 seconds)
      delay = List.last(queuers)
      |> DelayBuilder.build(space, 900)

      # Search for next available play time at specific space & game mode
      searchrange = Timex.now(space.timezone)
      |> Timex.to_erl()
      |> NaiveDateTime.from_erl!()
      |> SearchRangeBuilder.build(duration, delay)

      case PlayTimeUtil.next_available(space, game_mode, searchrange) do
        [%{game_area: game_area, available: available} | _] ->
          with {:ok, %Match{} = match} <- game_mode
               |> MatchBuilder.build()
               |> Accounts.create_match(),
               {:ok, _} <- MatchManager.matched(queuers)
          do
            users = queuers
            |> Enum.map(& Accounts.get_user!(&1.user_id))

            members_attrs = MatchMemberBuilder.build(match, users)
            Repo.insert_all(MatchMember, members_attrs)

            booking_attrs = %{
              kickoff: hd(available),
              duration: game_mode.duration,
              game_mode_id: game_mode.id,
              game_area_id: game_area.id,
              match_id: match.id
            }
            case Accounts.create_booking(booking_attrs) do
              {:ok, _} -> match
              {:error, _} -> Repo.rollback(:booking_error)
            end
          else
            {:error, _} -> Repo.rollback(:new_match_error)
          end
        [] -> Repo.rollback(:availability_error)
      end
    end
  end
end
