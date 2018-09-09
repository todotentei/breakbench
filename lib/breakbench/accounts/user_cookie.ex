defmodule Breakbench.Accounts.UserCookie do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:token, :string, []}
  schema "user_cookies" do
    field :user_agent, :string
    field :remote_ip, :string

    belongs_to :user, Breakbench.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_cookie, attrs) do
    user_cookie
    |> cast(attrs, [:token, :user_agent, :remote_ip, :user_id])
    |> validate_required([:token, :user_id])
  end
end
