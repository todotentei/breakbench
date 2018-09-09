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
  @spec changeset(term :: atom()) :: Ecto.Changeset.t()
  def changeset(:availability_mode) do
    MatchmakingAvailabilityMode.changeset(%MatchmakingAvailabilityMode{}, %{})
  end
  def changeset(:game_mode) do
    MatchmakingGameMode.changeset(%MatchmakingGameMode{}, %{})
  end
  def changeset(:queue) do
    MatchmakingQueue.changeset(%MatchmakingQueue{}, %{})
  end
  def changeset(:rule) do
    MatchmakingRule.changeset(%MatchmakingRule{}, %{})
  end
  def changeset(:space_distance_matrix) do
    MatchmakingSpaceDistanceMatrix.changeset(%MatchmakingSpaceDistanceMatrix{}, %{})
  end
  def changeset(:travel_mode) do
    MatchmakingTravelMode.changeset(%MatchmakingTravelMode{}, %{})
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
end
