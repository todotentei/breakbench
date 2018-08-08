defmodule Breakbench.Repo.Migrations.CreateAffectedFields do
  use Ecto.Migration

  def change do
    create table(:affected_fields, primary_key: false) do
      add :field_id, references(:fields, on_delete: :delete_all, type: :string),
        primary_key: true
      add :affected_id, references(:fields, on_delete: :delete_all, type: :string),
        primary_key: true
    end

    create constraint(:affected_fields, "ban_self_referencing", check: "field_id <> affected_id")
    create constraint(:affected_fields, "directionless", check: "field_id < affected_id")
  end
end
