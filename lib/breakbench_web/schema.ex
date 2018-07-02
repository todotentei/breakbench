defmodule BreakbenchWeb.Schema do
  use Absinthe.Schema

  alias BreakbenchWeb.AccountsResolver
  alias BreakbenchWeb.AddressComponentsResolver
  alias BreakbenchWeb.ExchangesResolver

  import_types Absinthe.Type.Custom

  object :country do
    field :short_name, non_null(:string)
    field :long_name, :string
  end

  object :currency do
    field :decimal_digits, :integer
    field :name, :string
    field :name_plural, :string
    field :symbol, :string
    field :symbol_native, :string
  end

  object :user do
    field :id, non_null(:id)
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


  ## Queries

  query do
    # Country
    field :all_countries, list_of(:country) do
      resolve &AddressComponentsResolver.all_countries/3
    end

    # Currency
    field :all_currencies, list_of(:currency) do
      resolve &ExchangesResolver.all_currencies/3
    end

    # User
    field :all_users, list_of(:user) do
      resolve &AccountsResolver.all_users/3
    end
    field :get_user, :user do
      arg :id, :id
      resolve &AccountsResolver.get_user/3
    end
    field :has_user, :boolean do
      arg :email, :string
      arg :username, :string
      resolve &AccountsResolver.has_user/3
    end
  end
end
