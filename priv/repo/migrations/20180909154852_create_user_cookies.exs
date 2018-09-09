defmodule Breakbench.Repo.Migrations.CreateUserCookies do
  use Ecto.Migration

  def change do
    create table(:user_cookies, primary_key: false) do
      add :token, :string, primary_key: true
      add :user_agent, :string
      add :remote_ip, :string
      add :user_id, references(:users, on_delete: :delete_all),
        null: false

      timestamps()
    end
  end
end
