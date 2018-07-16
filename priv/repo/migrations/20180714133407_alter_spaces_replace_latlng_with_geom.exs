defmodule Breakbench.Repo.Migrations.AlterSpacesReplaceLatlngWithGeom do
  use Ecto.Migration

  def change do
    alter table(:spaces) do
      remove :latitude
      remove :longitude

      add :geom, :"geometry(point,4326)"
    end
  end
end
