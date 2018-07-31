defmodule Breakbench.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Activities.{
    GameMode, Sport
  }


  # Game modes

  def list_game_modes do
    Repo.all(GameMode)
  end

  def get_game_mode!(id) do
    Repo.get!(GameMode, id)
  end

  def create_game_mode(attrs \\ %{}) do
    %GameMode{}
      |> GameMode.changeset(attrs)
      |> Repo.insert()
  end

  def update_game_mode(%GameMode{} = game_mode, attrs) do
    game_mode
      |> GameMode.changeset(attrs)
      |> Repo.update()
  end

  def delete_game_mode(%GameMode{} = game_mode) do
    Repo.delete(game_mode)
  end

  def change_game_mode(%GameMode{} = game_mode) do
    GameMode.changeset(game_mode, %{})
  end


  # Sports

  def list_sports do
    Repo.all(Sport)
  end

  def get_sport!(name), do: Repo.get!(Sport, name)

  def create_sport(attrs \\ %{}) do
    %Sport{}
      |> Sport.changeset(attrs)
      |> Repo.insert()
  end

  def update_sport(%Sport{} = sport, attrs) do
    sport
      |> Sport.changeset(attrs)
      |> Repo.update()
  end

  def delete_sport(%Sport{} = sport) do
    Repo.delete(sport)
  end

  def change_sport(%Sport{} = sport) do
    Sport.changeset(sport, %{})
  end
end
