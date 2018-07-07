defmodule Breakbench.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo
  alias Breakbench.Timesheets.TimeBlock


  ## Field

  alias Breakbench.Places.Field
  alias Breakbench.Places.FieldClosingHour
  alias Breakbench.Places.FieldDynamicPricing

  def list_fields do
    Repo.all(Field)
  end

  def list_field_closing_hours do
    Repo.all(FieldClosingHour)
  end

  def list_field_dynamic_pricings do
    Repo.all(FieldDynamicPricing)
  end

  def get_field!(id) do
    Repo.get!(Field, id)
  end

  def get_field_closing_hour!(id) do
    Repo.get!(FieldClosingHour, id)
  end

  def get_field_dynamic_pricing!(id) do
    Repo.get!(FieldDynamicPricing, id)
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

  def intersect_field_closing_hours(%Field{} = field, attrs) do
    field
      |> Ecto.assoc(:closing_hours)
      |> time_block_intersect_query(attrs)
      |> Repo.all()
  end

  def intersect_field_dynamic_pricings(%Field{} = field, price, attrs) do
    field
      |> Ecto.assoc(:dynamic_pricings)
      |> where(price: ^price)
      |> time_block_intersect_query(attrs)
      |> Repo.all()
  end


  ## Ground

  alias Breakbench.Places.Ground
  alias Breakbench.Places.GroundClosingHour

  def list_grounds do
    Repo.all(Ground)
  end

  def list_ground_closing_hours do
    Repo.all(GroundClosingHour)
  end

  def get_ground!(id) do
    Repo.get!(Ground, id)
  end

  def get_ground_closing_hour!(id) do
    Repo.get!(GroundClosingHour, id)
  end

  def create_ground(attrs \\ %{}) do
    %Ground{}
      |> Ground.changeset(attrs)
      |> Repo.insert()
  end

  def create_ground_closing_hour(attrs \\ %{}) do
    %GroundClosingHour{}
      |> GroundClosingHour.changeset(attrs)
      |> Repo.insert()
  end

  def intersect_ground_closing_hours(%Ground{} = ground, attrs) do
    ground
      |> Ecto.assoc(:closing_hours)
      |> time_block_intersect_query(attrs)
      |> Repo.all()
  end


  ## Space

  alias Breakbench.Places.Space
  alias Breakbench.Places.SpaceOpeningHour

  def list_spaces do
    Repo.all(Space)
  end

  def list_space_opening_hours do
    Repo.all(SpaceOpeningHour)
  end

  def get_space!(id) do
    Repo.get!(Space, id)
  end

  def get_space_opening_hour!(id) do
    Repo.get!(SpaceOpeningHour, id)
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
    Repo.delete(space)
  end

  def change_space(%Space{} = space) do
    Space.changeset(space, %{})
  end

  def change_space_opening_hour(%SpaceOpeningHour{} = space_opening_hour) do
    SpaceOpeningHour.changeset(space_opening_hour, %{})
  end

  def intersect_space_opening_hours(%Space{} = space, attrs) do
    space
      |> Ecto.assoc(:opening_hours)
      |> time_block_intersect_query(attrs)
      |> Repo.all()
  end


  ## Private

  defp time_block_intersect_query(query, attrs) do
    query
      |> join(:inner, [s], t in TimeBlock, s.time_block_id == t.id)
      |> where([_, t], t.day_of_week == ^attrs[:day_of_week])
      |> where([_, t], fragment("is_time_span_intersect((?,?),(?,?))",
         t.start_at, t.end_at, ^attrs[:start_at], ^attrs[:end_at]))
      |> where([_, t], fragment("is_valid_period_intersect((?,?),(?,?))",
         t.valid_from, t.valid_through, ^attrs[:valid_from], ^attrs[:valid_through]))
  end
end
