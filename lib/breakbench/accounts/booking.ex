defmodule Breakbench.Accounts.Booking do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bookings" do
    field :kickoff, :naive_datetime
    field :duration, :integer

    belongs_to :field, Breakbench.Regions.Field,
      type: :string
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id
    belongs_to :user, Breakbench.Accounts.User
    belongs_to :match, Breakbench.Accounts.Match,
      type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:kickoff, :duration, :field_id, :game_mode_id, :user_id, :match_id])
    |> validate_required([:kickoff, :duration, :field_id, :game_mode_id])
  end
end
