defmodule Breakbench.Facilities do
  @moduledoc "The Facilities context"

  import Ecto.Query, warn: false
  import Geo.PostGIS, warn: false
  alias Breakbench.Repo

  alias Breakbench.Facilities.{
    Area, Field, FieldClosingHour, FieldDynamicPricing, Space,
    SpaceOpeningHour
  }


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


  ## Field

  def list_fields do
    Repo.all Field
  end

  def list_field_closing_hours do
    Repo.all FieldClosingHour
  end

  def list_field_dynamic_pricings do
    Repo.all FieldDynamicPricing
  end

  def get_field!(id) do
    Repo.get! Field, id
  end

  def get_field_closing_hour!(id) do
    Repo.get! FieldClosingHour, id
  end

  def get_field_dynamic_pricing!(id) do
    Repo.get! FieldDynamicPricing, id
  end

  def create_field(attrs \\ %{}) do
    %Field{}
    |> Field.changeset(attrs)
    |> Repo.insert()
  end

  def create_field_closing_hour(attrs \\ %{}) do
    %FieldClosingHour{}
    |> FieldClosingHour.changeset(attrs)
    |> Repo.insert()
  end

  def create_field_dynamic_pricing(attrs \\ %{}) do
    %FieldDynamicPricing{}
    |> FieldDynamicPricing.changeset(attrs)
    |> Repo.insert()
  end


  ## Space

  def list_spaces do
    Repo.all Space
  end

  def list_spaces(%Geo.Point{} = point, radius) do
    from(Space)
    |> where([spc], st_dwithin_in_meters(spc.geom, ^point, ^radius))
    |> order_by([spc], st_distancesphere(spc.geom, ^point))
    |> Repo.all()
  end

  def list_space_opening_hours do
    Repo.all SpaceOpeningHour
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