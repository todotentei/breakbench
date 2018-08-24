defmodule Breakbench.Repo.Migrations.AlterSpacesAddServiceFee do
  use Ecto.Migration

  def change do
    alter table(:spaces) do
      add :service_fee, :float, null: false
    end

    create constraint(:spaces, "valid_service_fee",
      check: "service_fee >= 0 AND service_fee <= 1")
  end
end
