defmodule Breakbench.Matchmaking do
  @moduledoc """
  Matchmaking context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Matchmaking.{
    MatchmakingAvailabilityMode,
    MatchmakingGameMode,
    MatchmakingQueue,
    MatchmakingRule,
    MatchmakingSpaceDistanceMatrix,
    MatchmakingTravelMode
  }

  @doc """
  Generates a changeset for the matchmaking schemas.
  """
  @spec changeset(term :: atom(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(atom, attrs \\ %{})
  def changeset(:availability_mode, attrs) do
    MatchmakingAvailabilityMode.changeset(%MatchmakingAvailabilityMode{}, attrs)
  end
  def changeset(:game_mode, attrs) do
    MatchmakingGameMode.changeset(%MatchmakingGameMode{}, attrs)
  end
  def changeset(:queue, attrs) do
    MatchmakingQueue.changeset(%MatchmakingQueue{}, attrs)
  end
  def changeset(:rule, attrs) do
    MatchmakingRule.changeset(%MatchmakingRule{}, attrs)
  end
  def changeset(:space_distance_matrix, attrs) do
    MatchmakingSpaceDistanceMatrix.changeset(%MatchmakingSpaceDistanceMatrix{}, attrs)
  end
  def changeset(:travel_mode, attrs) do
    MatchmakingTravelMode.changeset(%MatchmakingTravelMode{}, attrs)
  end

  @doc """
  Returns all the matchmaking travel modes.
  """
  @spec list_travel_modes() :: [MatchmakingTravelMode.t()]
  def list_travel_modes do
    Repo.all(MatchmakingTravelMode)
  end

  @doc """
  Get a rule by a given clauses.
  """
  @spec get_rule_by!(attrs :: map()) :: MatchmakingRule.t()
  def get_rule_by!(attrs) do
    Repo.get_by!(MatchmakingRule, attrs)
  end

  @doc """
  Creates a matchmaking queue.
  """
  @spec create_queue(
    attrs :: map()
  ) :: {:ok, MatchmakingQueue.t()} | {:error, Ecto.Changeset.t()}
  def create_queue(attrs \\ %{}) do
    %MatchmakingQueue{}
    |> MatchmakingQueue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a matchmaking travel mode.
  """
  @spec create_travel_mode(
    attrs :: map()
  ) :: {:ok, MatchmakingTravelMode.t()} | {:error, Ecto.Changeset.t()}
  def create_travel_mode(attrs \\ %{}) do
    %MatchmakingTravelMode{}
    |> MatchmakingTravelMode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Inserts all matchmaking game mode entries.
  """
  @spec insert_all_game_modes(
    entries :: [map() | Keyword.t()]
  ) :: {integer(), nil | [term()]}
  def insert_all_game_modes(entries) do
    Repo.insert_all(MatchmakingGameMode, entries)
  end

  @doc """
  Inserts all matchmaking space distance matrix entries.
  """
  @spec insert_all_space_distance_matrix(
    entries :: [map() | Keyword.t()]
  ) :: {integer(), nil | [term()]}
  def insert_all_space_distance_matrix(entries) do
    Repo.insert_all(MatchmakingSpaceDistanceMatrix, entries)
  end
end
