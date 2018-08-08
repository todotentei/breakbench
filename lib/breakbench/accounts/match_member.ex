defmodule Breakbench.Accounts.MatchMember do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :id}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "match_members" do
    belongs_to :match, Breakbench.Accounts.Match,
      type: :binary_id
    belongs_to :user, Breakbench.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(match_member, attrs) do
    match_member
    |> cast(attrs, [:match_id, :user_id])
    |> validate_required([:match_id, :user_id])
  end
end
