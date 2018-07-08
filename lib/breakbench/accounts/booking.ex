defmodule Breakbench.Accounts.Booking do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bookings" do
    field :kickoff, :naive_datetime
    field :duration, :integer


    belongs_to :field, Breakbench.Places.Field,
      type: :string


    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
      |> cast(attrs, [:kickoff, :duration, :field_id])
      |> validate_required([:kickoff, :duration, :field_id])
  end
end
