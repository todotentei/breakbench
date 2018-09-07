defmodule BreakbenchWeb.ActivityNotation do
  use Absinthe.Schema.Notation
  import BreakbenchWeb.ActivityResolver

  # Context
  object :activity_queries do
    field :list_game_modes, list_of(:game_mode) do
      arg :sport, :string

      resolve & list_game_modes/3
    end

    field :list_sports, list_of(:sport) do
      resolve & list_sports/3
    end
  end

  # Game mode
  object :game_mode do
    field :id, :string
    field :name, :string
    field :number_of_players, :integer
    field :duration, :integer
  end

  # Sport
  object :sport do
    field :name, :string
    field :type, :string
  end
end
