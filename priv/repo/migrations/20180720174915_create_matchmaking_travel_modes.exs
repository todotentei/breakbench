defmodule Breakbench.Repo.Migrations.CreateMatchmaking.TravelModes do
  use Ecto.Migration

  def change do
    create table(:matchmaking_travel_modes, primary_key: false) do
      add :type, :citext, primary_key: true
    end
  end
end
