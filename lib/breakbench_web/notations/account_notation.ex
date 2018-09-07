defmodule BreakbenchWeb.AccountNotation do
  use Absinthe.Schema.Notation
  import BreakbenchWeb.AccountResolver

  # Context
  object :account_queries do
    field :list_users, list_of(:user) do
      resolve & list_users/3
    end

    field :has_user, :boolean do
      arg :email, :string
      arg :username, :string

      resolve & has_user/3
    end
  end

  # User
  object :user do
    field :id, :id
    field :full_name, :string
    field :given_name, :string
    field :email, :string
    field :date_of_birth, :date
    field :gender, :string
    field :username, :string
    field :profile, :string
    field :inserted_at, :datetime
    field :updated_at , :datetime
  end
end
