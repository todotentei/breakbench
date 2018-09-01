defmodule Breakbench.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :full_name, :string
    field :given_name, :string
    field :email, :string
    field :date_of_birth, :date
    field :gender, :string
    field :username, :string
    field :profile, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :stripe_customer, :string
    field :sessions, {:map, :integer}, default: %{}

    timestamps()
  end

  @doc false
  def registration_changeset(struct, attrs) do
    struct
      |> changeset(attrs)
      |> cast(attrs, [:password])
      |> validate_length(:password, min: 6, max: 100)
      |> put_pass_hash()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
      |> cast(attrs, [:full_name, :given_name, :email, :date_of_birth, :gender,
         :username, :profile, :stripe_customer, :sessions])
      |> validate_required([:email, :username])
      |> validate_length(:username, min: 1, max: 20)
      |> unique_constraint(:username)
      |> unique_constraint(:email)
  end


  ## Private

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        hashpwsalt = Comeonin.Bcrypt.hashpwsalt(pass)
        put_change(changeset, :password_hash, hashpwsalt)
      _ ->
        changeset
    end
  end
end
