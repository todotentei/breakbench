defmodule BreakbenchWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  import_types BreakbenchWeb.AccountNotation
  import_types BreakbenchWeb.ActivityNotation
  import_types BreakbenchWeb.MatchmakingNotation

  query do
    import_fields :account_queries
    import_fields :activity_queries
    import_fields :matchmaking_queries
  end
end
