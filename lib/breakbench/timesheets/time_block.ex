defmodule Breakbench.Timesheets.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "time_blocks" do
    field :day_of_week, :integer
    field :start_time, :integer
    field :end_time, :integer
    field :from_date, :date
    field :through_date, :date
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:day_of_week, :start_time, :end_time, :from_date, :through_date])
    |> validate_required([:day_of_week, :start_time, :end_time])
    |> check_constraint(:start_time, name: :valid_start_time)
    |> check_constraint(:end_time, name: :valid_end_time)
    |> check_constraint(:end_time, name: :positive_duration)
  end
end
