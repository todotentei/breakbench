defmodule BreakbenchWeb.Schema do
  use Absinthe.Schema

  alias BreakbenchWeb.{
    ActivitiesResolver,
    AccountsResolver,
    ExchangesResolver,
    MatchmakingResolver,
    RegionsResolver
  }

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

  object :game_mode do
    field :name, non_null(:string)
    field :number_of_players, :integer
    field :duration, :integer
  end

  object :matchmaking_travel_mode do
    field :type, non_null(:string)
  end

  object :sport do
    field :name, non_null(:string)
    field :type, :string
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
    ## Activities

    field :list_sport_game_modes, list_of(:game_mode) do
      arg :sport, :string
      resolve &ActivitiesResolver.list_sport_game_modes/3
    end

    field :list_sports, list_of(:sport) do
      resolve &ActivitiesResolver.list_sports/3
    end


    ## Country
    field :all_countries, list_of(:country) do
      resolve &RegionsResolver.all_countries/3
    end


    ## Currency
    field :all_currencies, list_of(:currency) do
      resolve &ExchangesResolver.all_currencies/3
    end


    ## Matchmaking

    field :list_matchmaking_travel_modes, list_of(:matchmaking_travel_mode) do
      resolve &MatchmakingResolver.list_travel_modes/3
    end


    ## User
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
