defmodule Breakbench.Accounts.Match do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "matches" do
    belongs_to :game_mode, Breakbench.Activities.GameMode,
      type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:game_mode_id])
    |> validate_required([:game_mode_id])
  end
end
