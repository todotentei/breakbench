defmodule Breakbench.Matchmaking do
  @moduledoc """
  Matchmaking context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS, warn: false
  alias Breakbench.Repo

  alias Breakbench.Activities.GameMode
  alias Breakbench.Facilities.Space
  alias Breakbench.Matchmaking.{
    MatchmakingAvailabilityMode, MatchmakingGameMode, MatchmakingQueue,
    MatchmakingRule, MatchmakingSpaceDistanceMatrix, MatchmakingTravelMode
  }


  # Availability modes

  def list_availability_modes do
    Repo.all(MatchmakingAvailabilityMode)
  end

  def get_availability_mode!(type) do
    Repo.get!(MatchmakingAvailabilityMode, type)
  end

  def create_availability_mode(attrs \\ %{}) do
    %MatchmakingAvailabilityMode{}
      |> MatchmakingAvailabilityMode.changeset(attrs)
      |> Repo.insert()
  end


  # Game modes

  def create_game_mode(attrs \\ %{}) do
    %MatchmakingGameMode{}
      |> MatchmakingGameMode.changeset(attrs)
      |> Repo.insert()
  end

  def delete_game_mode(%MatchmakingGameMode{} = matchmaking_game_mode) do
    Repo.delete(matchmaking_game_mode)
  end


  # Queues

  def list_queues do
    Repo.all(MatchmakingQueue)
  end

  def list_queues(%Space{} = space, %GameMode{} = game_mode) do
    from(MatchmakingQueue)
    |> where([mmq], mmq.id in fragment("SELECT queuers(?, ?)",
        ^space.id, type(^game_mode.id, :binary_id)))
    |> Repo.all
  end

  def list_queue_game_modes(%MatchmakingQueue{} = matchmaking_queue) do
    matchmaking_queue
      |> Ecto.assoc(:game_modes)
      |> Repo.all
  end

  def get_queue!(id) do
    Repo.get!(MatchmakingQueue, id)
  end

  def create_queue(attrs \\ %{}) do
    %MatchmakingQueue{}
      |> MatchmakingQueue.changeset(attrs)
      |> Repo.insert()
  end

  def update_queue(%MatchmakingQueue{} = queue, attrs) do
    queue
      |> MatchmakingQueue.changeset(attrs)
      |> Repo.update()
  end

  def delete_queue(%MatchmakingQueue{} = matchmaking_queue) do
    Repo.delete(matchmaking_queue)
  end

  def changeset_queue(attrs \\ %{}) do
    MatchmakingQueue.changeset(%MatchmakingQueue{}, attrs)
  end


  # Rules

  def list_rules do
    Repo.all(MatchmakingRule)
  end

  def get_rule!(id) do
    Repo.get!(MatchmakingRule, id)
  end

  def create_rule(attrs \\ %{}) do
    %MatchmakingRule{}
      |> MatchmakingRule.changeset(attrs)
      |> Repo.insert()
  end

  def update_rule(%MatchmakingRule{} = rule, attrs) do
    rule
      |> MatchmakingRule.changeset(attrs)
      |> Repo.update()
  end


  # Space distance matrices

  def create_space_distance_matrix(attrs \\ %{}) do
    %MatchmakingSpaceDistanceMatrix{}
      |> MatchmakingSpaceDistanceMatrix.changeset(attrs)
      |> Repo.update()
  end


  # Travel modes

  def list_travel_modes do
    Repo.all(MatchmakingTravelMode)
  end

  def get_travel_mode!(type) do
    Repo.get!(MatchmakingTravelMode, type)
  end

  def create_travel_mode(attrs \\ %{}) do
    %MatchmakingTravelMode{}
      |> MatchmakingTravelMode.changeset(attrs)
      |> Repo.insert()
  end
end
