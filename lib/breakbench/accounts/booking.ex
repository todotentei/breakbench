defmodule Breakbench.Accounts.Booking do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bookings" do
    field :kickoff, :naive_datetime
    field :duration, :integer
    field :price, :integer

    belongs_to :currency, Breakbench.Exchanges.Currency,
      primary_key: true, type: :string, foreign_key: :currency_code, references: :code
    belongs_to :game_area, Breakbench.Facilities.GameArea,
      type: :binary_id
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
    |> cast(attrs, [:kickoff, :duration, :price, :currency_code, :game_area_id,
      :game_mode_id, :user_id, :match_id])
    |> validate_required([:kickoff, :duration, :price, :currency_code, :game_area_id,
      :game_mode_id])
  end
end
