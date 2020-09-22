defmodule Aicacia.User.Repo.Migrations.CreatePasswords do
  use Ecto.Migration

  def change do
    create table(:passwords) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:encrypted_password, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:passwords, [:user_id]))
  end
end
