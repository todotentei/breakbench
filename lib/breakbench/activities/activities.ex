defmodule Breakbench.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Activities.{
    GameMode,
    Sport
  }
  alias Breakbench.Accounts.Match

  @doc """
  Generates a changeset for the activity schemas.
  """
  @spec changeset(term :: atom(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(atom, attrs \\ %{})
  def changeset(:game_mode, attrs) do
    GameMode.changeset(%GameMode{}, attrs)
  end
  def changeset(:sport, attrs) do
    Sport.changeset(%Sport{}, attrs)
  end

  @doc """
  Returns a sport's game modes.
  """
  @spec list_game_modes(term :: Sport.t()) :: [GameMode.t()]
  def list_game_modes(%Sport{} = sport) do
    sport
    |> Ecto.assoc(:game_modes)
    |> Repo.all()
  end

  @doc """
  Returns all the activity game modes.
  """
  @spec list_game_modes() :: [GameMode.t()]
  def list_game_modes do
    Repo.all(GameMode)
  end

  @doc """
  Returns all the sports.
  """
  @spec list_sports() :: [Sport.t()]
  def list_sports do
    Repo.all(Sport)
  end

  @doc """
  Get a game mode.
  """
  @spec get_game_mode!(term :: binary() | Match.t()) :: GameMode.t()
  def get_game_mode!(%Match{} = match) do
    match
    |> Ecto.assoc(:game_mode)
    |> Repo.one!()
  end
  def get_game_mode!(id) do
    Repo.get!(GameMode, id)
  end

  @doc """
  Get a sport.
  """
  @spec get_sport!(term :: binary()) :: Sport.t()
  def get_sport!(name), do: Repo.get!(Sport, name)
end
