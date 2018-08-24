defmodule Breakbench.Facilities do
  @moduledoc "The Facilities context"

  import Ecto.Query, warn: false
  import Geo.PostGIS, warn: false
  alias Breakbench.Repo

  alias Breakbench.Facilities.{
    Area, GameArea, GameAreaClosingHour, GameAreaDynamicPricing, Space,
    SpaceOpeningHour
  }
  alias Breakbench.Accounts.Booking


  ## Area

  def list_areas do
    Repo.all Area
  end

  def get_area!(id) do
    Repo.get! Area, id
  end

  def create_area(attrs \\ %{}) do
    %Area{}
    |> Area.changeset(attrs)
    |> Repo.insert()
  end

  def delete_area(%Area{} = area) do
    Repo.delete area
  end


  ## Game Area

  def list_game_areas do
    Repo.all GameArea
  end

  def list_game_area_closing_hours do
    Repo.all GameAreaClosingHour
  end

  def list_game_area_dynamic_pricings do
    Repo.all GameAreaDynamicPricing
  end

  def get_game_area!(id) do
    Repo.get! GameArea, id
  end

  def get_game_area_closing_hour!(id) do
    Repo.get! GameAreaClosingHour, id
  end

  def get_game_area_dynamic_pricing!(id) do
    Repo.get! GameAreaDynamicPricing, id
  end

  def create_game_area(attrs \\ %{}) do
    %GameArea{}
    |> GameArea.changeset(attrs)
    |> Repo.insert()
  end

  def create_game_area_closing_hour(attrs \\ %{}) do
    %GameAreaClosingHour{}
    |> GameAreaClosingHour.changeset(attrs)
    |> Repo.insert()
  end

  def create_game_area_dynamic_pricing(attrs \\ %{}) do
    %GameAreaDynamicPricing{}
    |> GameAreaDynamicPricing.changeset(attrs)
    |> Repo.insert()
  end


  ## Space

  def list_spaces do
    Repo.all Space
  end

  def list_space_opening_hours do
    Repo.all SpaceOpeningHour
  end

  def get_space!(%Booking{} = booking) do
    booking
    |> Ecto.assoc([:game_area, :area, :space])
    |> Repo.one!()
  end
  def get_space!(id) do
    Repo.get! Space, id
  end

  def get_space_opening_hour!(id) do
    Repo.get! SpaceOpeningHour, id
  end

  def create_space(attrs \\ %{}) do
    %Space{}
    |> Space.changeset(attrs)
    |> Repo.insert()
  end

  def create_space_opening_hour(attrs \\ %{}) do
    %SpaceOpeningHour{}
    |> SpaceOpeningHour.changeset(attrs)
    |> Repo.insert()
  end

  def update_space(%Space{} = space, attrs) do
    space
    |> Space.changeset(attrs)
    |> Repo.update()
  end

  def delete_space(%Space{} = space) do
    Repo.delete space
  end

  def change_space(%Space{} = space) do
    Space.changeset space, %{}
  end

  def change_space_opening_hour(%SpaceOpeningHour{} = space_opening_hour) do
    SpaceOpeningHour.changeset space_opening_hour, %{}
  end
end
