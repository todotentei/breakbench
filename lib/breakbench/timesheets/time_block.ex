defmodule Breakbench.Timesheets.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "time_blocks" do
    field :day_of_week, :integer
    field :start_at, :time
    field :end_at, :time
    field :valid_from, :naive_datetime
    field :valid_through, :naive_datetime
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
      |> cast(attrs, [:day_of_week, :start_at, :end_at, :valid_from, :valid_through])
      |> validate_required([:day_of_week, :start_at, :end_at])
  end
end
