defmodule Aicacia.Id.Repo.Migrations.CreateUsernames do
  use Ecto.Migration

  def change do
    create table(:usernames) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:username, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:usernames, [:user_id]))
    create(unique_index(:usernames, [:username]))
  end
end
