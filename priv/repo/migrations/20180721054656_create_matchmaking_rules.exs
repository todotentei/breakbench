defmodule Breakbench.Repo.Migrations.CreateMatchmaking.Rules do
  use Ecto.Migration

  def change do
    create table(:matchmaking_rules, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :travel_mode_type, references(:matchmaking_travel_modes, column: :type, type: :citext)
      add :availability_mode_type, references(:matchmaking_availability_modes, column: :type, type: :citext)
      add :max_radius, :integer
      add :radius_expansion_rate, :integer
    end

    create index(:matchmaking_rules, [:travel_mode_type])
    create index(:matchmaking_rules, [:availability_mode_type])
    create index(:matchmaking_rules, [:travel_mode_type, :availability_mode_type])
  end
end
