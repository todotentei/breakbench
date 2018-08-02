defmodule Breakbench.Timesheets.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "time_blocks" do
    field :day_of_week, :integer
    field :start_time, :time
    field :end_time, :time
    field :from_date, :date
    field :through_date, :date
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
      |> cast(attrs, [:day_of_week, :start_time, :end_time, :from_date, :through_date])
      |> validate_required([:day_of_week, :start_time, :end_time])
  end
end
