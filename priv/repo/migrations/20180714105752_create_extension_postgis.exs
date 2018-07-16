defmodule Breakbench.Repo.Migrations.CreateExtensionPostgis do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public"
  end

  def down do
    execute "DROP EXTENSION postgis"
  end
end
