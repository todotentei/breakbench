defmodule Breakbench.Places do
  @moduledoc """
  The Places context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo


  ## Space
  alias Breakbench.Places.Space

  def list_spaces do
    Repo.all(Space)
  end

  def get_space!(id), do: Repo.get!(Space, id)

  def create_space(attrs \\ %{}) do
    %Space{}
      |> Space.changeset(attrs)
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


  ## Space Opening Hour
  alias Breakbench.Places.SpaceOpeningHour


  def list_space_opening_hours do
    Repo.all(SpaceOpeningHour)
  end

  def get_space_opening_hour!(id), do: Repo.get!(SpaceOpeningHour, id)

  def create_space_opening_hour(attrs \\ %{}) do
    %SpaceOpeningHour{}
      |> SpaceOpeningHour.changeset(attrs)
      |> Repo.insert()
  end

  def intersect_space_opening_hours(%Space{} = space, attrs) do
    alias Breakbench.Timesheets.TimeBlock

    space
      |> Ecto.assoc(:opening_hours)
      |> join(:inner, [s], t in TimeBlock, s.time_block_id == t.id)
      |> where([_, t], t.day_of_week == ^attrs[:day_of_week])
      |> where([_, t], fragment("is_time_span_intersect((?,?),(?,?))",
         t.start_at, t.end_at, ^attrs[:start_at], ^attrs[:end_at]))
      |> where([_, t], fragment("is_valid_period_intersect((?,?),(?,?))",
         t.valid_from, t.valid_through, ^attrs[:valid_from], ^attrs[:valid_through]))
      |> Repo.all()
  end

  def change_space_opening_hour(%SpaceOpeningHour{} = space_opening_hour) do
    SpaceOpeningHour.changeset(space_opening_hour, %{})
  end
end
