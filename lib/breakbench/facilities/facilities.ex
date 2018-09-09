defmodule Breakbench.Facilities do
  @moduledoc "The Facilities context"

  import Ecto.Query, warn: false
  import Geo.PostGIS, warn: false
  alias Breakbench.Repo

  alias Breakbench.Facilities.{
    AffectedGameArea,
    AreaClosingHour,
    Area,
    GameAreaClosingHour,
    GameAreaDynamicPricing,
    GameAreaMode,
    GameArea,
    SpaceOpeningHour,
    Space,
  }
  alias Breakbench.Accounts.Booking

  @doc """
  Generates a changeset for the facility schemas.
  """
  @spec changeset(term :: atom(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(atom, attrs \\ %{})
  def changeset(:affected_game_area, attrs) do
    AffectedGameArea.changeset(%AffectedGameArea{}, attrs)
  end
  def changeset(:area_closing_hour, attrs) do
    AreaClosingHour.changeset(%AreaClosingHour{}, attrs)
  end
  def changeset(:area, attrs) do
    Area.changeset(%Area{}, attrs)
  end
  def changeset(:game_area_closing_hour, attrs) do
    GameAreaClosingHour.changeset(%GameAreaClosingHour{}, attrs)
  end
  def changeset(:game_area_dynamic_pricing, attrs) do
    GameAreaDynamicPricing.changeset(%GameAreaDynamicPricing{}, attrs)
  end
  def changeset(:game_area_mode, attrs) do
    GameAreaMode.changeset(%GameAreaMode{}, attrs)
  end
  def changeset(:game_area, attrs) do
    GameArea.changeset(%GameArea{}, attrs)
  end
  def changeset(:space_opening_hour, attrs) do
    SpaceOpeningHour.changeset(%SpaceOpeningHour{}, attrs)
  end
  def changeset(:space, attrs) do
    Space.changeset(%Space{}, attrs)
  end

  @doc """
  Returns all the game area closing hours.
  """
  @spec list_game_area_closing_hours() :: [GameAreaClosingHour.t()]
  def list_game_area_closing_hours do
    Repo.all GameAreaClosingHour
  end

  @doc """
  Returns all the game area dynamic pricings.
  """
  @spec list_game_area_dynamic_pricings() :: [GameAreaDynamicPricing.t()]
  def list_game_area_dynamic_pricings do
    Repo.all GameAreaDynamicPricing
  end

  @doc """
  Returns all the space opening hours.
  """
  @spec list_space_opening_hours() :: [SpaceOpeningHour.t()]
  def list_space_opening_hours do
    Repo.all SpaceOpeningHour
  end

  @doc """
  Get a game area closing hour.
  """
  @spec get_game_area_closing_hour!(term :: binary()) :: GameAreaClosingHour.t()
  def get_game_area_closing_hour!(id) do
    Repo.get! GameAreaClosingHour, id
  end

  @doc """
  Get a game area dynamic pricing.
  """
  @spec get_game_area_dynamic_pricing!(term :: binary()) :: GameAreaDynamicPricing.t()
  def get_game_area_dynamic_pricing!(id) do
    Repo.get! GameAreaDynamicPricing, id
  end

  @doc """
  Get a space.
  """
  @spec get_space!(term :: binary()) :: Space.t()
  def get_space!(%Booking{} = booking) do
    booking
    |> Ecto.assoc([:game_area, :area, :space])
    |> Repo.one!()
  end
  def get_space!(id) do
    Repo.get! Space, id
  end

  @doc """
  Get a space opening hour.
  """
  @spec get_space_opening_hour!(term :: binary()) :: SpaceOpeningHour.t()
  def get_space_opening_hour!(id) do
    Repo.get! SpaceOpeningHour, id
  end

  @doc """
  Creates a game area closing hour.
  """
  @spec create_game_area_closing_hour(
    attrs :: map()
  ) :: {:ok, GameAreaClosingHour.t()} | {:error, Ecto.Changeset.t()}
  def create_game_area_closing_hour(attrs \\ %{}) do
    %GameAreaClosingHour{}
    |> GameAreaClosingHour.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a game area dynamic pricing.
  """
  @spec create_game_area_dynamic_pricing(
    attrs :: map()
  ) :: {:ok, GameAreaDynamicPricing.t()} | {:error, Ecto.Changeset.t()}
  def create_game_area_dynamic_pricing(attrs \\ %{}) do
    %GameAreaDynamicPricing{}
    |> GameAreaDynamicPricing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a space opening hour.
  """
  @spec create_space_opening_hour(
    attrs :: map()
  ) :: {:ok, SpaceOpeningHour.t()} | {:error, Ecto.Changeset.t()}
  def create_space_opening_hour(attrs \\ %{}) do
    %SpaceOpeningHour{}
    |> SpaceOpeningHour.changeset(attrs)
    |> Repo.insert()
  end
end
