defmodule Breakbench.MatchFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Accounts.{
        Match, MatchMember
      }

      def match_factory do
        %Match{
          game_mode: build(:game_mode),
          inserted_at: NaiveDateTime.utc_now(),
          updated_at: NaiveDateTime.utc_now()
        }
      end

      def match_member_factory do
        %MatchMember{
          match: build(:match),
          user: build(:user),
          inserted_at: NaiveDateTime.utc_now(),
          updated_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
