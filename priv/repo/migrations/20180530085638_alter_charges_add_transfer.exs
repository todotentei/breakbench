defmodule Breakbench.Repo.Migrations.AlterChargesAddTransfer do
  use Ecto.Migration

  def change do
    alter table(:charges) do
      add :source_transfer_id, references(:transfers, type: :string, on_replace: :nilify)
      add :transfer_id, references(:transfers, type: :string, on_replace: :nilify)
      add :transfer_group, :string
    end

    create index(:charges, [:source_transfer_id])
    create index(:charges, [:transfer_id])
    create index(:charges, [:transfer_group])
  end
end
