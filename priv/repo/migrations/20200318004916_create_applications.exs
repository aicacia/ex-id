defmodule Aicacia.Id.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(
        :owner_id,
        references(:users, type: :binary_id, on_delete: :delete_all, on_update: :nothing),
        null: false
      )

      add(:redirect_uri, :string, null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:applications, [:owner_id]))
  end
end
